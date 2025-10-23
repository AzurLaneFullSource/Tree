pg = pg or {}
pg.SceneAnimMgr = singletonClass("SceneAnimMgr")

local var0_0 = pg.SceneAnimMgr

function var0_0.Ctor(arg0_1)
	arg0_1.loadingList = {}
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

function var0_0.CommonSceneChange(arg0_10, arg1_10, arg2_10)
	table.insert(arg0_10.loadingList, {
		arg1_10,
		arg2_10
	})

	if not arg0_10.playing then
		arg0_10:DoSceneChange()
	end
end

function var0_0.DoSceneChange(arg0_11)
	arg0_11.playing = true

	setActive(arg0_11._tf, true)
	pg.UIMgr.GetInstance():LoadingOn(false)

	local var0_11, var1_11 = unpack(table.remove(arg0_11.loadingList, 1))
	local var2_11 = arg0_11.container:Find(var0_11)
	local var3_11 = {}

	if not var2_11 then
		table.insert(var3_11, function(arg0_12)
			PoolMgr.GetInstance():GetUI(var0_11, true, function(arg0_13)
				var2_11 = arg0_13.transform

				setParent(var2_11, arg0_11.container, false)
				arg0_12()
			end)
		end)
	end

	table.insert(var3_11, function(arg0_14)
		arg0_11:StartLoading(var0_11, var2_11, arg0_14)
	end)
	table.insert(var3_11, function(arg0_15)
		local var0_15

		local function var1_15()
			if #arg0_11.loadingList > 0 and arg0_11.loadingList[1][1] == var0_11 then
				var0_11, var1_11 = unpack(table.remove(arg0_11.loadingList, 1))

				var1_11(var1_15)
			else
				arg0_15()
			end
		end

		var1_11(var1_15)
		arg0_11:LoopLoading(var0_11, var2_11)
	end)
	table.insert(var3_11, function(arg0_17)
		arg0_11:EndLoading(var0_11, var2_11, arg0_17)
	end)
	seriesAsync(var3_11, function()
		PoolMgr.GetInstance():ReturnUI(var0_11, var2_11.gameObject)
		pg.UIMgr.GetInstance():LoadingOff()

		if #arg0_11.loadingList > 0 then
			arg0_11:DoSceneChange()
		else
			arg0_11.playing = nil

			setActive(arg0_11._tf, false)
		end
	end)
end

function var0_0.StartLoading(arg0_19, arg1_19, arg2_19, arg3_19)
	switch(arg1_19, {
		Dorm3DLoading = function()
			GetComponent(arg2_19, typeof(Animator)):SetBool("Finish", false)

			local var0_20 = arg2_19:Find("bg"):GetComponent(typeof(Image)).material

			var0_20:SetInt("_DissolveTexFlip", 1)
			LeanTween.value(1, 0, 0.6):setOnUpdate(System.Action_float(function(arg0_21)
				var0_20:SetFloat("_Dissolve", arg0_21)
			end)):setEase(LeanTweenType.easeOutCubic)
			arg2_19:GetComponent("DftAniEvent"):SetTriggerEvent(arg3_19)
			quickPlayAnimator(arg2_19, "anim_dorm3d_loading_in")
		end,
		IslandplaneLoading = function()
			arg2_19:GetComponent("DftAniEvent"):SetTriggerEvent(arg3_19)
			quickPlayAnimation(arg2_19, "anim_planeLoading_in")
			arg2_19:Find("load"):GetComponent("SkeletonAnimation").state:SetAnimation(0, "cut_in", false)
		end,
		IslandcarLoading = function()
			arg2_19:GetComponent("DftAniEvent"):SetTriggerEvent(arg3_19)
			quickPlayAnimation(arg2_19, "anim_planeLoading_in")
			arg2_19:Find("load"):GetComponent("SkeletonAnimation").state:SetAnimation(0, "cut_in", false)
		end,
		jufengyuziyouqundao = function()
			arg2_19 = arg2_19:Find("scale")

			arg2_19:GetComponent("DftAniEvent"):SetTriggerEvent(arg3_19)
			quickPlayAnimator(arg2_19, "jufeng")
		end,
		jufengyuziyouqundao_fullscreen = function()
			arg2_19 = arg2_19:Find("scale")

			arg2_19:GetComponent("DftAniEvent"):SetTriggerEvent(arg3_19)
			quickPlayAnimator(arg2_19, "jufeng")
		end
	}, function()
		return
	end)
end

function var0_0.LoopLoading(arg0_27, arg1_27, arg2_27)
	switch(arg1_27, {
		Dorm3DLoading = function()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_loading_loop")
		end,
		IslandplaneLoading = function()
			arg2_27:Find("load"):GetComponent("SkeletonAnimation").state:SetAnimation(0, "normal", true)
		end,
		IslandcarLoading = function()
			arg2_27:Find("load"):GetComponent("SkeletonAnimation").state:SetAnimation(0, "normal", true)
		end
	}, function()
		return
	end)
end

function var0_0.EndLoading(arg0_32, arg1_32, arg2_32, arg3_32)
	switch(arg1_32, {
		Dorm3DLoading = function()
			local var0_33 = arg2_32:Find("bg"):GetComponent(typeof(Image)).material

			var0_33:SetInt("_DissolveTexFlip", 0)
			LeanTween.value(0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0_34)
				var0_33:SetFloat("_Dissolve", arg0_34)
			end)):setEase(LeanTweenType.easeInOutCubic)
			arg2_32:GetComponent("DftAniEvent"):SetEndEvent(arg3_32)
			GetComponent(arg2_32, typeof(Animator)):SetBool("Finish", true)
		end,
		IslandplaneLoading = function()
			arg2_32:GetComponent("DftAniEvent"):SetEndEvent(arg3_32)
			quickPlayAnimation(arg2_32, "anim_planeLoading_out")
		end,
		IslandcarLoading = function()
			arg2_32:GetComponent("DftAniEvent"):SetEndEvent(arg3_32)
			quickPlayAnimation(arg2_32, "anim_planeLoading_out")
		end,
		jufengyuziyouqundao = function()
			arg3_32()
		end,
		jufengyuziyouqundao_fullscreen = function()
			arg3_32()
		end
	}, function()
		return
	end)
end

function var0_0.RegisterDormNextCall(arg0_40, arg1_40)
	function arg0_40.dormNextCall()
		arg0_40.dormNextCall = nil

		return arg1_40()
	end
end

function var0_0.Dorm3DSceneChange(arg0_42, arg1_42)
	table.insert(arg0_42.dormCallbackList, arg1_42)

	if not arg0_42.playing then
		pg.UIMgr.GetInstance():LoadingOn(false)
		arg0_42:DoDorm3DSceneChange()
	end

	existCall(arg0_42.dormNextCall)
end

function var0_0.DoDorm3DSceneChange(arg0_43, arg1_43)
	arg0_43.playing = true

	setActive(arg0_43._tf, true)

	local var0_43 = "Dorm3DLoading"
	local var1_43 = {}

	if not arg1_43 then
		table.insert(var1_43, function(arg0_44)
			PoolMgr.GetInstance():GetUI(var0_43, true, function(arg0_45)
				arg1_43 = arg0_45.transform

				setParent(arg1_43, arg0_43.container, false)
				arg0_44()
			end)
		end)
	end

	seriesAsync(var1_43, function()
		local var0_46 = arg1_43:Find("bg"):GetComponent(typeof(Image)).material
		local var1_46 = arg1_43:GetComponent("DftAniEvent")

		var1_46:SetTriggerEvent(function(arg0_47)
			local var0_47

			local function var1_47()
				if #arg0_43.dormCallbackList > 0 then
					table.remove(arg0_43.dormCallbackList, 1)(var1_47)
				else
					GetComponent(arg1_43, typeof(Animator)):SetBool("Finish", true)
					var0_46:SetInt("_DissolveTexFlip", 0)
					LeanTween.value(0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0_49)
						var0_46:SetFloat("_Dissolve", arg0_49)
					end)):setEase(LeanTweenType.easeInOutCubic)
				end
			end

			var1_47()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_loading_loop")
		end)
		var1_46:SetEndEvent(function(arg0_50)
			if #arg0_43.dormCallbackList > 0 then
				quickPlayAnimator(arg1_43, "anim_dorm3d_loading_in")
				arg0_43:DoDorm3DSceneChange(arg1_43)
			else
				PoolMgr.GetInstance():ReturnUI(var0_43, arg1_43.gameObject)

				arg0_43.playing = nil

				setActive(arg0_43._tf, false)
				pg.UIMgr.GetInstance():LoadingOff()
			end
		end)
		GetComponent(arg1_43, typeof(Animator)):SetBool("Finish", false)
		var0_46:SetInt("_DissolveTexFlip", 1)
		LeanTween.value(1, 0, 0.6):setOnUpdate(System.Action_float(function(arg0_51)
			var0_46:SetFloat("_Dissolve", arg0_51)
		end)):setEase(LeanTweenType.easeOutCubic)
	end)
end

function var0_0.IsPlaying(arg0_52)
	return arg0_52.playing
end

function var0_0.Dispose(arg0_53)
	setActive(arg0_53._tf, false)

	arg0_53.playing = nil
end
