       TTL ARM64 /GS cookie check compiler helper
;++
;
; Copyright (c) Microsoft Corporation
;
; Module Name:
;
;    secpushpop.asm
;
; Abstract:
;
;    ARM64 security cookie push & pop helpers
;
; Purpose:
;    ARM64 prologue & epilogue helpers to save code size in functions
;    with /GS cookies.
;

#include "arm64/arm64asmsymbolname.h"
#include "ksarm64.h"

        TEXTAREA

        IMPORT __security_cookie

#if defined(_M_ARM64EC)

        IMPORT A64NAME(__security_check_cookie_arm64ec)

#else

        IMPORT __security_check_cookie

#endif

        TEXTAREA

; void __security_push_cookie()
;
;
        NESTED_ENTRY A64NAME(__security_push_cookie)

        PROLOG_STACK_ALLOC 16
        adrp    x17, __security_cookie
        ldr     x17, [x17, __security_cookie] ; :LOW12:
        sub     x17, sp, x17
        str     x17, [sp, #8]

        EPILOG_RETURN

        NESTED_END A64NAME(__security_push_cookie)

        NESTED_ENTRY A64NAME(__security_pop_cookie)
        adrp    x17, __security_cookie
        ldr     x16, [sp, #8]
        ldr     x17, [x17, __security_cookie] ; :LOW12:
        sub     x16, sp, x16
        cmp     x16, x17
        bne     %F10

        EPILOG_STACK_FREE 16
        EPILOG_RETURN_CLEAR_UNWIND_TO_CALLER

10      mov     x0, x16
        ; __fallthrough to __ppgsfailure

        NESTED_END A64NAME(__security_pop_cookie)

        NESTED_ENTRY __ppgsfailure

        PROLOG_SAVE_REG_PAIR fp, lr, #16

        ; go through "standard" cookie processing

#if defined(_M_ARM64EC)
        bl       A64NAME(__security_check_cookie_arm64ec)
#else
        bl       __security_check_cookie
#endif

        EPILOG_RESTORE_REG_PAIR fp, lr, #16
        EPILOG_RETURN

        NESTED_END __ppgsfailure

        END
