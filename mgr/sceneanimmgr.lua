pg = pg or {}
pg.SceneAnimMgr = singletonClass("SceneAnimMgr")

local var0_0 = pg.SceneAnimMgr

function var0_0.Ctor(arg0_1)
	return
end

function var0_0.Init(arg0_2, arg1_2)
	print("initializing sceneanim manager...")
	PoolMgr.GetInstance():GetUI("SceneAnimUI", true, function(arg0_3)
		arg0_2._go = arg0_3

		arg0_2._go:SetActive(false)

		arg0_2._tf = arg0_2._go.transform

		arg0_2._tf:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0_2.container = arg0_2._tf:Find("container")

		if arg1_2 then
			arg1_2()
		end
	end)
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

function var0_0.Dorm3DSceneChange(arg0_10, arg1_10)
	setActive(arg0_10._tf, true)

	local var0_10 = "SixthAnniversaryJPCoverUI"

	PoolMgr.GetInstance():GetUI(var0_10, true, function(arg0_11)
		local var0_11 = arg0_11.transform

		setParent(var0_11, arg0_10.container, false)

		local var1_11 = var0_11:Find("houshanyunwu"):GetComponent(typeof(SpineAnimUI))

		var1_11:SetActionCallBack(function(arg0_12)
			if arg0_12 == "action" then
				var1_11:Pause()
				arg1_10(function()
					var1_11:Resume()
				end)
			elseif arg0_12 == "finish" then
				PoolMgr.GetInstance():ReturnUI(var0_10, arg0_11)

				arg0_10.playing = nil

				setActive(arg0_10._tf, false)
			end
		end)
		var1_11:SetAction("action", 0)
	end)
end

function var0_0.IsPlaying(arg0_14)
	return arg0_14.playing
end

function var0_0.Dispose(arg0_15)
	setActive(arg0_15._tf, false)

	arg0_15.playing = nil
end
