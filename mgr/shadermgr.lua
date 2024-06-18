pg = pg or {}

local var0_0 = pg

var0_0.ShaderMgr = singletonClass("ShaderMgr")

local var1_0 = var0_0.ShaderMgr

function var0_0.ShaderMgr.Init(arg0_1, arg1_1)
	print("initializing shader manager...")
	Shader.DisableKeyword("LOW_DEVICE_PERFORMANCE")

	local function var0_1(arg0_2)
		ResourceMgr.Inst:LoadShaderAndCached("shader", arg0_2, false, false)
	end

	local function var1_1(arg0_3)
		ResourceMgr.Inst:LoadShaderAndCached("l2dshader", arg0_3, false, false)
	end

	local function var2_1(arg0_4)
		ResourceMgr.Inst:LoadShaderAndCached("spineshader", arg0_4, false, false)
	end

	local function var3_1(arg0_5)
		arg0_5()
	end

	local function var4_1(arg0_6)
		ResourceMgr.Inst:LoadShaderAndCached("builtinpipeline/shaders", arg0_6, false, false)
	end

	local var5_1 = {
		var0_1,
		var1_1,
		var2_1,
		var3_1,
		var4_1
	}

	parallelAsync(var5_1, function()
		originalPrint("所有shader加载完成")
		arg1_1()
	end)
end

function var1_0.GetShader(arg0_8, arg1_8)
	return (ResourceMgr.Inst:GetShader(arg1_8))
end

function var1_0.GetBlurMaterialSync(arg0_9)
	if arg0_9.blurMaterial ~= nil then
		return arg0_9.blurMaterial
	else
		local var0_9 = arg0_9:GetShader("Hidden/MobileBlur")

		arg0_9.blurMaterial = Material.New(var0_9)

		arg0_9.blurMaterial:SetVector("_Parameter", Vector4.New(1, -1, 0, 0))

		return arg0_9.blurMaterial
	end
end

function var1_0.BlurTexture(arg0_10, arg1_10)
	local var0_10 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	})
	local var1_10 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	})

	var0_10.filterMode = ReflectionHelp.RefGetField(typeof("UnityEngine.FilterMode"), "Bilinear")

	local var2_10 = arg0_10:GetBlurMaterialSync()

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.Material"),
		typeof("System.Int32")
	}, {
		arg1_10,
		var0_10,
		var2_10,
		0
	})

	for iter0_10 = 0, 1 do
		var2_10:SetVector("_Parameter", Vector4.New(1 + iter0_10, -1 - iter0_10, 0, 0))
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			var0_10,
			var1_10,
			var2_10,
			1
		})
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			var1_10,
			var0_10,
			var2_10,
			2
		})
	end

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		var1_10
	})

	return var0_10
end

function var1_0.SetSpineUIOutline(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:GetShader("M02/Unlit Colored_Alpha_UI_Outline")
	local var1_11 = GetComponent(arg1_11, "SkeletonGraphic")
	local var2_11 = Material.New(var0_11)

	var2_11:SetColor("_OutlineColor", arg2_11)
	var2_11:SetFloat("_OutlineWidth", 5.75)
	var2_11:SetFloat("_ThresholdEnd", 0.2)

	var1_11.material = var2_11
end

function var1_0.DelSpineUIOutline(arg0_12, arg1_12)
	GetComponent(arg1_12, "SkeletonGraphic").material = nil
end
