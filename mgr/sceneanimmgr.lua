pg = pg or {}
pg.SceneAnimMgr = singletonClass("SceneAnimMgr")

local var0_0 = pg.SceneAnimMgr

function var0_0.Ctor(arg0_1)
	arg0_1.dormCallbackList = {}
end

function var0_0.Init(arg0_2, arg1_2)
	print("initializing sceneanim manager...")
	LoadAndInstantiateAsync("ui", "SceneAnimUI", function(arg0_3)
		arg0_2._go = arg0_3

		arg0_2._go:SetActive(false)

		arg0_2._tf = arg0_2._go.transform

		arg0_2._tf:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0_2.container = arg0_2._tf:Find("container")

		if arg1_2 then
			arg1_2()
		end
	end, true, true)
end

function var0_0.SixthAnniversaryJPCoverGoScene(arg0_4, arg1_4)
	arg0_4.playing = true

	setActive(arg0_4._tf, true)

	local var0_4 = "SixthAnniversaryJPCoverUI"

	PoolMgr.GetInstance():GetUI(var0_4, true, function(arg0_5)
		local var0_5 = arg0_5.transform

		setParent(var0_5, arg0_4.container, false)
		setActive(var0_5, true)

		local var1_5 = var0_5:Find("houshanyunwu"):GetComponent(typeof(SpineAnimUI))

		var1_5:SetActionCallBack(function(arg0_6)
			if arg0_6 == "finish" then
				PoolMgr.GetInstance():ReturnUI(var0_4, arg0_5)

				arg0_4.playing = nil

				setActive(var0_5, false)
				setActive(arg0_4._tf, false)
			elseif arg0_6 == "action" then
				pg.m02:sendNotification(GAME.GO_SCENE, arg1_4)
			end
		end)
		var1_5:SetAction("action", 0)
	end)
end

function var0_0.OtherWorldCoverGoScene(arg0_7, arg1_7, arg2_7)
	arg0_7.playing = true

	setActive(arg0_7._tf, true)

	local var0_7 = "OtherworldCoverUI"

	PoolMgr.GetInstance():GetUI(var0_7, true, function(arg0_8)
		local var0_8 = arg0_8.transform

		setParent(var0_8, arg0_7.container, false)
		setActive(var0_8, true)

		local var1_8 = var0_8:Find("yuncaizhuanchang"):GetComponent(typeof(SpineAnimUI))

		var1_8:SetActionCallBack(function(arg0_9)
			if arg0_9 == "finish" then
				PoolMgr.GetInstance():ReturnUI(var0_7, arg0_8)

				arg0_7.playing = nil

				setActive(var0_8, false)
				setActive(arg0_7._tf, false)
			elseif arg0_9 == "action" then
				pg.m02:sendNotification(GAME.GO_SCENE, arg1_7, arg2_7)
			end
		end)
		var1_8:SetAction("action", 0)
	end)
end

function var0_0.RegisterDormNextCall(arg0_10, arg1_10)
	function arg0_10.dormNextCall()
		arg0_10.dormNextCall = nil

		return arg1_10()
	end
end

function var0_0.Dorm3DSceneChange(arg0_12, arg1_12)
	table.insert(arg0_12.dormCallbackList, arg1_12)

	if not arg0_12.playing then
		pg.UIMgr.GetInstance():LoadingOn(false)
		arg0_12:DoDorm3DSceneChange()
	end

	existCall(arg0_12.dormNextCall)
end

function var0_0.DoDorm3DSceneChange(arg0_13, arg1_13)
	arg0_13.playing = true

	setActive(arg0_13._tf, true)

	local var0_13 = "Dorm3DLoading"
	local var1_13 = {}

	if not arg1_13 then
		table.insert(var1_13, function(arg0_14)
			PoolMgr.GetInstance():GetUI(var0_13, true, function(arg0_15)
				arg1_13 = arg0_15.transform

				setParent(arg1_13, arg0_13.container, false)
				arg0_14()
			end)
		end)
	end

	seriesAsync(var1_13, function()
		local var0_16 = arg1_13:Find("bg"):GetComponent(typeof(Image)).material
		local var1_16 = arg1_13:GetComponent("DftAniEvent")

		var1_16:SetTriggerEvent(function(arg0_17)
			local var0_17

			local function var1_17()
				if #arg0_13.dormCallbackList > 0 then
					table.remove(arg0_13.dormCallbackList, 1)(var1_17)
				else
					GetComponent(arg1_13, typeof(Animator)):SetBool("Finish", true)
					var0_16:SetInt("_DissolveTexFlip", 0)
					LeanTween.value(0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0_19)
						var0_16:SetFloat("_Dissolve", arg0_19)
					end)):setEase(LeanTweenType.easeInOutCubic)
				end
			end

			var1_17()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_loading_loop")
		end)
		var1_16:SetEndEvent(function(arg0_20)
			if #arg0_13.dormCallbackList > 0 then
				quickPlayAnimator(arg1_13, "anim_dorm3d_loading_in")
				arg0_13:DoDorm3DSceneChange(arg1_13)
			else
				PoolMgr.GetInstance():ReturnUI(var0_13, arg1_13.gameObject)

				arg0_13.playing = nil

				setActive(arg0_13._tf, false)
				pg.UIMgr.GetInstance():LoadingOff()
			end
		end)
		GetComponent(arg1_13, typeof(Animator)):SetBool("Finish", false)
		var0_16:SetInt("_DissolveTexFlip", 1)
		LeanTween.value(1, 0, 0.6):setOnUpdate(System.Action_float(function(arg0_21)
			var0_16:SetFloat("_Dissolve", arg0_21)
		end)):setEase(LeanTweenType.easeOutCubic)
	end)
end

function var0_0.IsPlaying(arg0_22)
	return arg0_22.playing
end

function var0_0.Dispose(arg0_23)
	setActive(arg0_23._tf, false)

	arg0_23.playing = nil
end
