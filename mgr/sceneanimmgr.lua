pg = pg or {}
pg.SceneAnimMgr = singletonClass("SceneAnimMgr")

local var0 = pg.SceneAnimMgr

function var0.Ctor(arg0)
	return
end

function var0.Init(arg0, arg1)
	print("initializing sceneanim manager...")
	PoolMgr.GetInstance():GetUI("SceneAnimUI", true, function(arg0)
		arg0._go = arg0

		arg0._go:SetActive(false)

		arg0._tf = arg0._go.transform

		arg0._tf:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0.container = arg0._tf:Find("container")

		if arg1 then
			arg1()
		end
	end)
end

function var0.SixthAnniversaryJPCoverGoScene(arg0, arg1)
	arg0.playing = true

	setActive(arg0._tf, true)

	local var0 = "SixthAnniversaryJPCoverUI"

	PoolMgr.GetInstance():GetUI(var0, true, function(arg0)
		local var0 = arg0.transform

		setParent(var0, arg0.container, false)
		setActive(var0, true)

		local var1 = var0:Find("houshanyunwu"):GetComponent(typeof(SpineAnimUI))

		var1:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				PoolMgr.GetInstance():ReturnUI(var0, arg0)

				arg0.playing = nil

				setActive(var0, false)
				setActive(arg0._tf, false)
			elseif arg0 == "action" then
				pg.m02:sendNotification(GAME.GO_SCENE, arg1)
			end
		end)
		var1:SetAction("action", 0)
	end)
end

function var0.OtherWorldCoverGoScene(arg0, arg1, arg2)
	arg0.playing = true

	setActive(arg0._tf, true)

	local var0 = "OtherworldCoverUI"

	PoolMgr.GetInstance():GetUI(var0, true, function(arg0)
		local var0 = arg0.transform

		setParent(var0, arg0.container, false)
		setActive(var0, true)

		local var1 = var0:Find("yuncaizhuanchang"):GetComponent(typeof(SpineAnimUI))

		var1:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				PoolMgr.GetInstance():ReturnUI(var0, arg0)

				arg0.playing = nil

				setActive(var0, false)
				setActive(arg0._tf, false)
			elseif arg0 == "action" then
				pg.m02:sendNotification(GAME.GO_SCENE, arg1, arg2)
			end
		end)
		var1:SetAction("action", 0)
	end)
end

function var0.Dorm3DSceneChange(arg0, arg1)
	setActive(arg0._tf, true)

	local var0 = "SixthAnniversaryJPCoverUI"

	PoolMgr.GetInstance():GetUI(var0, true, function(arg0)
		local var0 = arg0.transform

		setParent(var0, arg0.container, false)

		local var1 = var0:Find("houshanyunwu"):GetComponent(typeof(SpineAnimUI))

		var1:SetActionCallBack(function(arg0)
			if arg0 == "action" then
				var1:Pause()
				arg1(function()
					var1:Resume()
				end)
			elseif arg0 == "finish" then
				PoolMgr.GetInstance():ReturnUI(var0, arg0)

				arg0.playing = nil

				setActive(arg0._tf, false)
			end
		end)
		var1:SetAction("action", 0)
	end)
end

function var0.IsPlaying(arg0)
	return arg0.playing
end

function var0.Dispose(arg0)
	setActive(arg0._tf, false)

	arg0.playing = nil
end
