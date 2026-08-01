#include "Utils/MemoryMgr.h"
#include "Utils/Patterns.h"

#define RwEngineInstance (*rwengine)

#include <rwcore.h>
#include "RWGTA.h"

// GTA versions of RenderWare functions/macros for GTA III/Vice City
// since we cannot use RwEngineInstance directly

// Anything originally using RwEngineInstance shall be redefined here
// Functions which RW 3.6 inlined can also easily be defined here

void** rwengine = []() -> void** {
	// Thanks Steam III...

	// Locate RwRenderStateSet
	try
	{
		auto renderStateSetPtr = hook::txn::get_pattern( "D1 7C 24 2C", 4 );
		auto renderStateSet = reinterpret_cast<uintptr_t>(Memory::ReadCallFrom( renderStateSetPtr ));

		// Test III 1.0/1.1/VC
		if ( *reinterpret_cast<uint8_t*>(renderStateSet) == 0xA1 )
		{
			return *reinterpret_cast<void***>(renderStateSet + 1);
		}

		// Test III Steam
		renderStateSet += 3;
		if ( *reinterpret_cast<uint8_t*>(renderStateSet) == 0xA1 )
		{
			return *reinterpret_cast<void***>(renderStateSet + 1);
		}
	}
	TXN_CATCH();

	assert(!"Could not locate RwEngineInstance!");
	return nullptr;
}();

static decltype(::RwD3D8SetRenderState)* fnRwD3D8SetRenderState;
RwBool RwD3D8SetRenderState(RwUInt32 state, RwUInt32 value)
{
	return fnRwD3D8SetRenderState(state, value);
}

static decltype(::RwD3D8GetRenderState)* fnRwD3D8GetRenderState;
void RwD3D8GetRenderState(RwUInt32 state, void* value)
{
	fnRwD3D8GetRenderState(state, value);
}

RwReal RwIm2DGetNearScreenZ()
{
	return RWSRCGLOBAL(dOpenDevice).zBufferNear;
}

RwBool RwRenderStateGet(RwRenderState state, void *value)
{
	return RWSRCGLOBAL(dOpenDevice).fpRenderStateGet(state, value);
}

RwBool RwRenderStateSet(RwRenderState state, void *value)
{
	return RWSRCGLOBAL(dOpenDevice).fpRenderStateSet(state, value);
}

// Unreachable stub
RwBool RwMatrixDestroy(RwMatrix* /*mpMat*/) { assert(!"Unreachable!"); return TRUE; }

bool RWGTA::Patches::TryLocateRwD3D8() try
{
	using namespace Memory;
	using namespace hook::txn;

	// Attempt to locate RwD3D9 render state functions exported by SkyGfx or rwd3d9 backend wrappers
	const char* moduleNames[] = { "rwd3d9.dll", "skygfx.asi", "skygfx.dll" };
	for (const char* modName : moduleNames)
	{
		if (HMODULE hModule = GetModuleHandleA(modName))
		{
			auto pfnD3D9Set = (decltype(RwD3D8SetRenderState)*)GetProcAddress(hModule, "RwD3D9SetRenderState");
			auto pfnD3D9Get = (decltype(RwD3D8GetRenderState)*)GetProcAddress(hModule, "RwD3D9GetRenderState");

			if (pfnD3D9Set && pfnD3D9Get)
			{
				fnRwD3D8SetRenderState = pfnD3D9Set;
				fnRwD3D8GetRenderState = pfnD3D9Get;
				return true;
			}
		}
	}

	auto pfnRwD3D8SetRenderState = [] {
		try {
			// Everything except for III Steam
			return static_cast<decltype(RwD3D8SetRenderState)*>(get_pattern("39 0C C5 ? ? ? ? 74 31", -8));
		} catch (const hook::txn_exception&) {
			// III Steam
			return static_cast<decltype(RwD3D8SetRenderState)*>(get_pattern("8B 0C C5 ? ? ? ? 3B CA", -8));
		}
	}();
	auto pfnRwD3D8GetRenderState = [] {
		try {
			// Everything except for III Steam
			return static_cast<decltype(RwD3D8GetRenderState)*>(get_pattern("8B 0C C5 ? ? ? ? 89 0A C3", -8));
		} catch (const hook::txn_exception&) {
			// III Steam
			return static_cast<decltype(RwD3D8GetRenderState)*>(get_pattern("8B 04 C5 ? ? ? ? 89 02 C3", -8));
		}
	}();

	fnRwD3D8SetRenderState = pfnRwD3D8SetRenderState;
	fnRwD3D8GetRenderState = pfnRwD3D8GetRenderState;
	return true;
}
catch (const hook::txn_exception&)
{
	return false;
}