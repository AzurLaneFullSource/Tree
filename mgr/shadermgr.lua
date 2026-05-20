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
		if not EDITOR_TOOL then
			seriesAsync({
				function(arg0_7)
					ResourceMgr.Inst:unloadUnusedAssetBundles()
					onDelayTick(arg0_7, 0.0001)
				end,
				function(arg0_8)
					ResourceMgr.Inst:loadAssetBundleAsync("custom_builtin", function(arg0_9)
						arg0_9:Unload(false)
						onDelayTick(arg0_8, 0.0001)
					end)
				end,
				function(arg0_10)
					var1_0.cacheCustomBuiltin = UnityEngine.AssetBundle.LoadFromFile(PathMgr.getAssetBundle("custom_builtin"))

					arg0_10()
				end
			}, arg0_6)
		else
			ResourceMgr.Inst:LoadShaderAndCached("custom_builtin", arg0_6, false, false)
		end
	end

	local var5_1 = {
		var0_1,
		var1_1,
		var2_1,
		var3_1
	}

	var4_1(function()
		parallelAsync(var5_1, function()
			arg1_1()
		end)
	end)
end

function var1_0.GetShader(arg0_13, arg1_13)
	return (ResourceMgr.Inst:GetShader(arg1_13))
end

function var1_0.GetBlurMaterialSync(arg0_14)
	if arg0_14.blurMaterial ~= nil then
		return arg0_14.blurMaterial
	else
		local var0_14 = arg0_14:GetShader("Hidden/MobileBlur")

		arg0_14.blurMaterial = Material.New(var0_14)

		arg0_14.blurMaterial:SetVector("_Parameter", Vector4.New(1, -1, 0, 0))

		return arg0_14.blurMaterial
	end
end

function var1_0.BlurTexture(arg0_15, arg1_15)
	local var0_15 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	})
	local var1_15 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	})

	var0_15.filterMode = ReflectionHelp.RefGetField(typeof("UnityEngine.FilterMode"), "Bilinear")

	local var2_15 = arg0_15:GetBlurMaterialSync()

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.Material"),
		typeof("System.Int32")
	}, {
		arg1_15,
		var0_15,
		var2_15,
		0
	})

	for iter0_15 = 0, 1 do
		var2_15:SetVector("_Parameter", Vector4.New(1 + iter0_15, -1 - iter0_15, 0, 0))
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			var0_15,
			var1_15,
			var2_15,
			1
		})
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			var1_15,
			var0_15,
			var2_15,
			2
		})
	end

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		var1_15
	})

	return var0_15
end

function var1_0.SetSpineUIOutline(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:GetShader("M02/Unlit Colored_Alpha_UI_Outline")
	local var1_16 = GetComponent(arg1_16, "SkeletonGraphic")
	local var2_16 = Material.New(var0_16)

	var2_16:SetColor("_OutlineColor", arg2_16)
	var2_16:SetFloat("_OutlineWidth", 5.75)
	var2_16:SetFloat("_ThresholdEnd", 0.2)

	var1_16.material = var2_16
end

function var1_0.DelSpineUIOutline(arg0_17, arg1_17)
	GetComponent(arg1_17, "SkeletonGraphic").material = nil
end
