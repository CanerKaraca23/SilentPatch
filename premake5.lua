function LoadVersionMeta(folder)
    local f = io.open(folder .. "/versionmeta.props", "r")
    if f then
        local content = f:read("*all")
        f:close()
        local macros = {}
        for k, v in content:gmatch("<([%w_]+)>([^<]+)</[%w_]+>") do
            if k:match("^SILENTPATCH_") then
                table.insert(macros, k .. "=" .. v)
            end
        end
        if #macros > 0 then
            print("Loaded " .. #macros .. " macros for " .. folder)
            defines(macros)
        end
    end
end

workspace "SilentPatch"
    architecture "x86"
    configurations { "Debug", "Release", "Shipping" }
    
    language "C++"
    cppdialect "C++latest"
    systemversion "latest"
    characterset "Unicode"
    warnings "Extra"
    rtti "Off"
    vectorextensions "AVX2"
    
    buildoptions {
        "/Zc:threadSafeInit-",
        "/Zc:strictStrings",
        "/Zc:preprocessor"
    }
    
    linkoptions {
        "/DELAYLOAD:shell32.dll",
        "/DELAYLOAD:shlwapi.dll"
    }
    
    links { "delayimp.lib" }
    
    largeaddressaware "On"

    filter "configurations:Debug"
        targetdir "%{wks.location}/Debug"
        defines { "_HAS_EXCEPTIONS=0" }
        runtime "Debug"
        symbols "On"
        optimize "Off"

    filter "configurations:Release"
        targetdir "%{wks.location}/Release"
        defines { "_HAS_EXCEPTIONS=0" }
        runtime "Release"
        optimize "Speed"

        stringpooling "On"
        inlining "Auto"
        omitframepointer "On"

    filter "configurations:Shipping"
        targetdir "%{wks.location}/Shipping"
        defines { "_HAS_EXCEPTIONS=0", "NDEBUG" }
        runtime "Release"
        optimize "Speed"

        stringpooling "On"
        inlining "Auto"
        omitframepointer "On"
        symbols "Off"
        linktimeoptimization "On"
        buildoptions { "/Gw" }
        linkoptions { "/pdbaltpath:%_PDB%" }

    filter {}



project "SilentPatchIII"
    location "SilentPatchIII"
    LoadVersionMeta("SilentPatchIII")
    kind "SharedLib"
    targetextension ".asi"
    targetname "SilentPatchIII"
    
    includedirs {
        "$(RWG33SDK)/include/d3d8",
        "SilentPatch",
        "SilentPatchIII"
    }
    
    defines {
        "PATTERNS_USE_HINTS=1",
        "_GTA_III"
    }
    
    files {
        "SilentPatch/Common.cpp",
        "SilentPatch/Common_ddraw.cpp",
        "SilentPatch/Desktop.cpp",
        "SilentPatch/ParseUtils.cpp",
        "SilentPatch/RWGTA.cpp",
        "SilentPatch/StoredCar.cpp",
        "SilentPatch/SVF.cpp",
        "SilentPatch/TheFLAUtils.cpp",
        "SilentPatch/Timer.cpp",
        "SilentPatch/Utils/Patterns.cpp",
        
        "SilentPatchIII/ModelInfoIII.cpp",
        "SilentPatchIII/PhysicalIII.cpp",
        "SilentPatchIII/SilentPatchIII.cpp",
        "SilentPatchIII/StdAfxIII.cpp",
        
        "SilentPatch/Common.h",
        "SilentPatch/Common_ddraw.h",
        "SilentPatch/debugmenu_public.h",
        "SilentPatch/Desktop.h",
        "SilentPatch/Maths.h",
        "SilentPatch/ParseUtils.hpp",
        "SilentPatch/Random.h",
        "SilentPatch/RWGTA.h",
        "SilentPatch/StdAfx.h",
        "SilentPatch/StoredCar.h",
        "SilentPatch/SVF.h",
        "SilentPatch/TheFLAUtils.h",
        "SilentPatch/Timer.h",
        "SilentPatch/Utils/MemoryMgr.h",
        "SilentPatch/Utils/Patterns.h",
        
        "SilentPatchIII/ModelInfoIII.h",
        "SilentPatchIII/PhysicalIII.h",
        "SilentPatchIII/VehicleIII.h",
        
        "SilentPatch/SilentPatch.rc",
        "SilentPatch/ExternalBindings.natvis"
    }
    
    pchheader "StdAfx.h"
    pchsource "SilentPatchIII/StdAfxIII.cpp"

    filter "files:SilentPatch/**.cpp"
        enablepch "Off"
    filter {}

project "SilentPatchVC"
    location "SilentPatchVC"
    LoadVersionMeta("SilentPatchVC")
    kind "SharedLib"
    targetextension ".asi"
    targetname "SilentPatchVC"
    
    includedirs {
        "$(RWG34SDK)/include/d3d8",
        "SilentPatch",
        "SilentPatchVC"
    }
    
    defines {
        "PATTERNS_USE_HINTS=1",
        "_GTA_VC"
    }
    
    files {
        "SilentPatch/Common.cpp",
        "SilentPatch/Common_ddraw.cpp",
        "SilentPatch/Desktop.cpp",
        "SilentPatch/ParseUtils.cpp",
        "SilentPatch/RWGTA.cpp",
        "SilentPatch/StoredCar.cpp",
        "SilentPatch/SVF.cpp",
        "SilentPatch/TheFLAUtils.cpp",
        "SilentPatch/Timer.cpp",
        "SilentPatch/Utils/Patterns.cpp",
        
        "SilentPatchVC/ModelInfoVC.cpp",
        "SilentPatchVC/SilentPatchVC.cpp",
        "SilentPatchVC/StdAfxVC.cpp",
        "SilentPatchVC/VehicleVC.cpp",
        
        "SilentPatch/Common_ddraw.h",
        "SilentPatch/debugmenu_public.h",
        "SilentPatch/Desktop.h",
        "SilentPatch/Maths.h",
        "SilentPatch/ParseUtils.hpp",
        "SilentPatch/Random.h",
        "SilentPatch/RWGTA.h",
        "SilentPatch/RWUtils.hpp",
        "SilentPatch/StdAfx.h",
        "SilentPatch/StoredCar.h",
        "SilentPatch/SVF.h",
        "SilentPatch/TheFLAUtils.h",
        "SilentPatch/Timer.h",
        "SilentPatch/Utils/MemoryMgr.h",
        "SilentPatch/Utils/Patterns.h",
        
        "SilentPatchVC/EntityVC.h",
        "SilentPatchVC/ModelInfoVC.h",
        "SilentPatchVC/VehicleVC.h",
        
        "SilentPatch/SilentPatch.rc",
        "SilentPatch/ExternalBindings.natvis"
    }
    
    pchheader "StdAfx.h"
    pchsource "SilentPatchVC/StdAfxVC.cpp"

    filter "files:SilentPatch/**.cpp"
        enablepch "Off"
    filter {}

project "SilentPatchSA"
    location "SilentPatchSA"
    LoadVersionMeta("SilentPatchSA")
    kind "SharedLib"
    targetextension ".asi"
    targetname "SilentPatchSA"
    
    includedirs {
        "$(RWG36SDK)/include/d3d9",
        "SilentPatch",
        "SilentPatchSA"
    }
    
    defines {
        "PATTERNS_USE_HINTS=1",
        "_GTA_SA"
    }
    
    filter "configurations:Shipping"
        defines { "_SECURE_SCL=0" }
    filter {}
	
    ignoredefaultlibraries { "libcmt" }
    disablewarnings { "5054" }
    
    files {
        "SilentPatch/Desktop.cpp",
        "SilentPatch/FriendlyMonitorNames.cpp",
        "SilentPatch/ParseUtils.cpp",
        "SilentPatch/SVF.cpp",
        "SilentPatch/TheFLAUtils.cpp",
        "SilentPatch/Utils/Patterns.cpp",
        
        "SilentPatchSA/AudioHardwareSA.cpp",
        "SilentPatchSA/EventsSA.cpp",
        "SilentPatchSA/FireManagerSA.cpp",
        "SilentPatchSA/FLACDecoderSA.cpp",
        "SilentPatchSA/GeneralSA.cpp",
        "SilentPatchSA/ModelInfoSA.cpp",
        "SilentPatchSA/PedSA.cpp",
        "SilentPatchSA/PlayerInfoSA.cpp",
        "SilentPatchSA/PNGFile.cpp",
        "SilentPatchSA/PoolsSA.cpp",
        "SilentPatchSA/ScriptSA.cpp",
        "SilentPatchSA/SilentPatchSA.cpp",
        "SilentPatchSA/StdAfxSA.cpp",
        "SilentPatchSA/TimerSA.cpp",
        "SilentPatchSA/VehicleSA.cpp",
        "SilentPatchSA/WaveDecoderSA.cpp",
        
        "SilentPatch/debugmenu_public.h",
        "SilentPatch/Desktop.h",
        "SilentPatch/FriendlyMonitorNames.h",
        "SilentPatch/Maths.h",
        "SilentPatch/ParseUtils.hpp",
        "SilentPatch/Random.h",
        "SilentPatch/RWUtils.hpp",
        "SilentPatch/SVF.h",
        "SilentPatch/TheFLAUtils.h",
        "SilentPatch/Utils/MemoryMgr.h",
        "SilentPatch/Utils/Patterns.h",
        
        "SilentPatchSA/AnimationSA.h",
        "SilentPatchSA/AudioHardwareSA.h",
        "SilentPatchSA/EventsSA.h",
        "SilentPatchSA/FireManagerSA.h",
        "SilentPatchSA/FLACDecoderSA.h",
        "SilentPatchSA/GeneralSA.h",
        "SilentPatchSA/LinkListSA.h",
        "SilentPatchSA/ModelInfoSA.h",
        "SilentPatchSA/PedSA.h",
        "SilentPatchSA/PlayerInfoSA.h",
        "SilentPatchSA/PNGFile.h",
        "SilentPatchSA/PoolsSA.h",
        "SilentPatchSA/resource.h",
        "SilentPatchSA/ScriptSA.h",
        "SilentPatchSA/SpeechContextsSA.h",
        "SilentPatchSA/StdAfxSA.h",
        "SilentPatchSA/TimerSA.h",
        "SilentPatchSA/VehicleSA.h",
        "SilentPatchSA/WaveDecoderSA.h",
        
        "SilentPatchSA/lunar64.png",
        
        "SilentPatch/SilentPatch.rc",
        "SilentPatchSA/SilentPatchSA.rc",
        "SilentPatch/ExternalBindings.natvis"
    }
    
    pchheader "StdAfxSA.h"
    pchsource "SilentPatchSA/StdAfxSA.cpp"

    filter "files:SilentPatch/**.cpp"
        enablepch "Off"
    filter {}

project "DDraw"
    location "DDraw"
    LoadVersionMeta("DDraw")
    kind "SharedLib"
    targetname "ddraw"
    targetextension ".dll"
    
    includedirs {
        "SilentPatch",
        "DDraw"
    }
    
    files {
        "SilentPatch/Common_ddraw.cpp",
        "SilentPatch/Desktop.cpp",
        "SilentPatch/Utils/Patterns.cpp",
        "DDraw/dllmain.cpp",
        
        "SilentPatch/Common_ddraw.h",
        "SilentPatch/Desktop.h",
        "SilentPatch/Utils/MemoryMgr.h",
        "SilentPatch/Utils/Patterns.h",
        
        "SilentPatch/SilentPatch.rc",
        "DDraw/ddraw.def",
        "SilentPatch/ExternalBindings.natvis"
    }
    
    linkoptions { "/DEF:ddraw.def" }
