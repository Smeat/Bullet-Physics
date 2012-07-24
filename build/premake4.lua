--add the 0 so the solution comes first in the directory (when sorted on name)
--print "uncomment this hello premake4 world for debugging the script"

solution "0BulletSolution"

	 newoption {
    trigger     = "ios",
    description = "Enable iOS target (requires xcode4)"
  }
  
	newoption {
		trigger = "with-demos",
	  description = "Enable demos and extras"	
	}

	newoption {
    trigger     = "with-nacl",
    description = "Enable Native Client build"
  }
  
  newoption {
    trigger     = "with-dx11",
    description = "Enable DirectX11 build"
  }
  
   newoption {
    trigger     = "with-opencl",
    description = "Enable OpenCL builds (various SDKs)"
  }

   newoption {
    trigger     = "with-opencl-amd",
    description = "Enable OpenCL builds (AMD SDK)"
  }

   newoption {
    trigger     = "with-opencl-intel",
    description = "Enable OpenCL builds (Intel SDK)"
  }
   newoption {
    trigger     = "with-opencl-nvidia",
    description = "Enable OpenCL builds (NVIDIA SDK)"
  }

  
	configurations {"Release", "Debug"}
	configuration "Release"
		flags { "Optimize", "StaticRuntime", "NoMinimalRebuild", "FloatFast"}
	configuration "Debug"
		flags { "Symbols", "StaticRuntime" , "NoMinimalRebuild", "NoEditAndContinue" ,"FloatFast"}
		
	platforms {"x32", "x64"}
	--platforms {"x32"}

  configuration {"Windows"}
  	defines { "_CRT_SECURE_NO_WARNINGS","_CRT_SECURE_NO_DEPRECATE"}
  
	configuration{}

	postfix="";

	if _ACTION == "xcode4" then
		if _OPTIONS["ios"] then
			postfix = "ios";
			defines {"ARM_NEON_GCC_COMPATIBILITY"}
			xcodebuildsettings
			{
				'INFOPLIST_FILE = "../../Test/Info.plist"',
				'CODE_SIGN_IDENTITY = "iPhone Developer"',
				"SDKROOT = iphoneos",
				'ARCHS = "armv7"',
				'TARGETED_DEVICE_FAMILY = "1,2"',
				'VALID_ARCHS = "armv7"',
			}	
			else
			xcodebuildsettings
			{
				'ARCHS = "$(ARCHS_STANDARD_32_BIT) $(ARCHS_STANDARD_64_BIT)"',
				'VALID_ARCHS = "x86_64 i386"',
			}
		end
	else
	
	end

	configuration {"x32"}
		targetsuffix ("_" .. _ACTION)
	configuration "x64"		
		targetsuffix ("_" .. _ACTION .. "_64" )
	configuration {"x64", "debug"}
		targetsuffix ("_" .. _ACTION .. "_x64_debug")
	configuration {"x64", "release"}
		targetsuffix ("_" .. _ACTION .. "_x64_release" )
	configuration {"x32", "debug"}
		targetsuffix ("_" .. _ACTION .. "_debug" )
	
	configuration{}



if not _OPTIONS["with-nacl"] then

	flags { "NoRTTI"}
	targetdir "../bin"

	-- Disable exception handling on MSVC 2008 and higher. MSVC 2005 without service pack has some linker issue (ConvexDecompositionDemo uses STL through HACD library)	
	if _ACTION == "vs2010" or _ACTION=="vs2008" then
		flags { "NoExceptions"}
		defines { "_HAS_EXCEPTIONS=0" }
	end

	-- Multithreaded compiling
	if _ACTION == "vs2010" then
		buildoptions { "/MP"  }
	end 


else
	targetdir "../bin_html"
end


	dofile ("findOpenCL.lua")
	dofile ("findDirectX11.lua")
	
	language "C++"
	
	location("./" .. _ACTION .. postfix)

	
	if _OPTIONS["with-dx11"] then
		include "../Demos/DX11ClothDemo"
		include "../src/BulletMultiThreaded/GpuSoftBodySolvers/DX11"
	end

--choose any OpenCL sdk that is installed on the system
	if _OPTIONS["with-opencl"] then
		include "../Demos/OpenCLClothDemo/AMD"
		include "../src/BulletMultiThreaded/GpuSoftBodySolvers/OpenCL/AMD"
		include "../Demos/OpenCLClothDemo/NVidia"
		include "../src/BulletMultiThreaded/GpuSoftBodySolvers/OpenCL/NVidia"
		include "../Demos/OpenCLClothDemo/Intel"
		include "../src/BulletMultiThreaded/GpuSoftBodySolvers/OpenCL/Intel"
	end

--choose a particular OpenCL sdk, this is useful for distributing project files that just work for one OpenCL SDK	
	if _OPTIONS["with-opencl-amd"] then
		include "../Demos/OpenCLClothDemo/AMD"
		include "../Demos/OpenGL"
		include "../Demos/SoftDemo/AMD"
		include "../src/BulletMultiThreaded/GpuSoftBodySolvers/OpenCL/AMD"
	end
  
  if _OPTIONS["with-opencl-intel"] then
		include "../Demos/OpenCLClothDemo/Intel"
		include "../src/BulletMultiThreaded/GpuSoftBodySolvers/OpenCL/Intel"
	end

  if _OPTIONS["with-opencl-nvidia"] then
		include "../Demos/OpenCLClothDemo/NVidia"
		include "../src/BulletMultiThreaded/GpuSoftBodySolvers/OpenCL/NVidia"
	end

	if _OPTIONS["with-demos"] then
		include "../Demos"
  	include "../Extras"
  end
  
  
   if _OPTIONS["with-nacl"] then
  	include "../Demos/NativeClient"
  else
  	include "../src/LinearMath"	
		include "../src/BulletCollision"	
		include "../src/BulletDynamics"	
		include "../src/BulletSoftBody"	
	end
	
	include "../Test"
	include "../Demos/HelloWorld"
	include "../Demos/Benchmarks"
	
