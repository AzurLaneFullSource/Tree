pg = pg or {}

local var0 = pg

var0.ShaderMgr = singletonClass("ShaderMgr")

local var1 = var0.ShaderMgr

function var0.ShaderMgr.Init(arg0, arg1)
	print("initializing shader manager...")
	Shader.DisableKeyword("LOW_DEVICE_PERFORMANCE")

	local function var0(arg0)
		ResourceMgr.Inst:LoadShaderAndCached("shader", arg0, false, false)
	end

	local function var1(arg0)
		ResourceMgr.Inst:LoadShaderAndCached("l2dshader", arg0, false, false)
	end

	local function var2(arg0)
		ResourceMgr.Inst:LoadShaderAndCached("spineshader", arg0, false, false)
	end

	local function var3(arg0)
		arg0()
	end

	local function var4(arg0)
		ResourceMgr.Inst:LoadShaderAndCached("builtinpipeline/shaders", arg0, false, false)
	end

	local var5 = {
		var0,
		var1,
		var2,
		var3,
		var4
	}

	parallelAsync(var5, function()
		originalPrint("所有shader加载完成")
		arg1()
	end)
end

function var1.GetShader(arg0, arg1)
	return (ResourceMgr.Inst:GetShader(arg1))
end

function var1.GetBlurMaterialSync(arg0)
	if arg0.blurMaterial ~= nil then
		return arg0.blurMaterial
	else
		local var0 = arg0:GetShader("Hidden/MobileBlur")

		arg0.blurMaterial = Material.New(var0)

		arg0.blurMaterial:SetVector("_Parameter", Vector4.New(1, -1, 0, 0))

		return arg0.blurMaterial
	end
end

function var1.BlurTexture(arg0, arg1)
	local var0 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	})
	local var1 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	})

	var0.filterMode = ReflectionHelp.RefGetField(typeof("UnityEngine.FilterMode"), "Bilinear")

	local var2 = arg0:GetBlurMaterialSync()

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.Material"),
		typeof("System.Int32")
	}, {
		arg1,
		var0,
		var2,
		0
	})

	for iter0 = 0, 1 do
		var2:SetVector("_Parameter", Vector4.New(1 + iter0, -1 - iter0, 0, 0))
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			var0,
			var1,
			var2,
			1
		})
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			var1,
			var0,
			var2,
			2
		})
	end

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		var1
	})

	return var0
end

function var1.SetSpineUIOutline(arg0, arg1, arg2)
	local var0 = arg0:GetShader("M02/Unlit Colored_Alpha_UI_Outline")
	local var1 = GetComponent(arg1, "SkeletonGraphic")
	local var2 = Material.New(var0)

	var2:SetColor("_OutlineColor", arg2)
	var2:SetFloat("_OutlineWidth", 5.75)
	var2:SetFloat("_ThresholdEnd", 0.2)

	var1.material = var2
end

function var1.DelSpineUIOutline(arg0, arg1)
	GetComponent(arg1, "SkeletonGraphic").material = nil
end
