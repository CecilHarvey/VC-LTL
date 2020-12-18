#include "winapi_thunks.h"


//xkeycheck.h���C�����޷��ض���һЩC++�ؼ��ִ���
#ifndef __cplusplus
	#define _ALLOW_KEYWORD_MACROS
#endif

#if _CRT_NTDDI_MIN >= NTDDI_VISTA
#ifndef _CRT_WINDOWS_USE_VISTA_TSS
#define _CRT_WINDOWS_USE_VISTA_TSS 1
#endif
#endif

typedef PTP_WORK (WINAPI * PFNCREATETHREADPOOLWORK)(_In_ PTP_WORK_CALLBACK pfnwk, _Inout_opt_ PVOID pv, _In_opt_ PTP_CALLBACK_ENVIRON pcbe);
typedef BOOLEAN  (WINAPI * PFNTRYACQUIRESRWLOCKEXCLUSIVE)(_Inout_ PSRWLOCK SRWLock);
typedef VOID     (WINAPI * PFNINITIALIZECONDITIONVARIABLE)(_Out_ PCONDITION_VARIABLE ConditionVariable);

#define DYNAMICGETCACHEDFUNCTION(Module, FunType, FunName, FunPtr)                \
    FunType FunPtr = (FunType)GetProcAddress(GetModuleHandleA(#Module),#FunName)