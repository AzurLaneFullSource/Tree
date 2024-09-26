pg = pg or {}
pg.ClickEffectMgr = singletonClass("ClickEffectMgr")

local var0_0 = pg.ClickEffectMgr

var0_0.CONFIG = {
	NORMAL = {
		"ui",
		"ClickEffect"
	},
	DORM3D = {
		"dorm3d/effect/prefab/ui",
		"vfx_ui_dianji01"
	}
}

function var0_0.Init(arg0_1, arg1_1)
	print("initializing click effect manager...")

	arg0_1.OverlayCamera = tf(GameObject.Find("OverlayCamera"))
	arg0_1.OverlayEffect = arg0_1.OverlayCamera:Find("Overlay/UIEffect")
	arg0_1.OverlayEffectClickCom = arg0_1.OverlayEffect:GetComponent("ClickEffectBehaviour")

	arg0_1.OverlayEffectClickCom:Init(arg0_1.OverlayCamera:GetComponent("Camera"), arg0_1.OverlayEffect)

	arg0_1.effectClick = nil
	arg0_1.effectDic = {}

	local var0_1 = PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0

	SetActive(arg0_1.OverlayEffect, var0_1)
	arg0_1:SetClickEffect("NORMAL", nil, nil, arg1_1)
end

function var0_0.ClearClickEffect(arg0_2)
	if arg0_2.clickEffect then
		arg0_2.OverlayEffectClickCom:UnRegisterEffect()
		SetActive(arg0_2.clickEffect, false)

		arg0_2.clickEffect = nil
	end
end

function var0_0.SetClickEffect(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	if not arg0_3.CONFIG[arg1_3] then
		return
	end

	local var0_3 = arg0_3.CONFIG[arg1_3][1]
	local var1_3 = arg0_3.CONFIG[arg1_3][2]

	arg0_3:ClearClickEffect()

	arg0_3.clickEffect = arg0_3.effectDic[var1_3]

	local function var2_3()
		arg0_3.OverlayEffectClickCom:RegisterEffect(arg0_3.clickEffect, arg2_3, arg3_3)

		if arg4_3 then
			arg4_3()
		end
	end

	if arg0_3.clickEffect then
		var2_3()
	else
		LoadAndInstantiateAsync(var0_3, var1_3, function(arg0_5)
			arg0_3.effectDic[var1_3] = go(arg0_5)

			setParent(arg0_3.effectDic[var1_3], arg0_3.OverlayEffect)

			arg0_3.clickEffect = arg0_3.effectDic[var1_3]

			var2_3()
		end)
	end
end
