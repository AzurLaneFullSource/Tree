local var0_0 = class("IdolMasterView", import("..BaseMiniGameView"))
local var1_0 = "backyard"
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = "event:/ui/sou"
local var4_0 = "event:/ui/xueqiu"
local var5_0 = 60
local var6_0 = 100
local var7_0 = 10
local var8_0 = {
	{
		20,
		3
	},
	{
		40,
		4
	},
	{
		60,
		5
	},
	{
		10000,
		5
	}
}
local var9_0 = {
	{
		10700031,
		10700030
	},
	{
		10700041,
		10700040
	},
	{
		10700051,
		10700050
	},
	{
		10700061,
		10700060
	},
	{
		10700071,
		10700070
	}
}
local var10_0 = {
	{
		10700011,
		10700010
	},
	{
		10700021,
		10700020
	}
}
local var11_0 = "EVENT_SEND_GIFT"
local var12_0 = "EVENT_FANS_ACTION"
local var13_0 = {
	1,
	2,
	3,
	4,
	5,
	6
}
local var14_0 = {
	1,
	2
}
local var15_0 = {
	3,
	4,
	5,
	6
}
local var16_0 = 3
local var17_0 = "dafuweng_event"
local var18_0 = "stand2"
local var19_0 = "normal"
local var20_0 = "work"
local var21_0 = "wrong"
local var22_0 = "end1"
local var23_0 = "end2"
local var24_0 = "gift"
local var25_0 = "normal"
local var26_0 = "walk"
local var27_0 = 3
local var28_0 = "type_fans_fail"
local var29_0 = "type_fans_success"
local var30_0 = 4
local var31_0 = {
	Vector3(160, 160),
	Vector3(160, -30),
	Vector3(160, -210),
	Vector3(160, -400)
}
local var32_0 = 350

local function var33_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		Ctor = function(arg0_2)
			arg0_2._giftTf = arg0_1
			arg0_2._event = arg2_1
			arg0_2._workerTf = arg1_1

			local var0_2 = "jiu-work"

			PoolMgr.GetInstance():GetSpineChar(var0_2, true, function(arg0_3)
				arg0_3.transform.localScale = Vector3.one
				arg0_3.transform.localPosition = Vector3.zero

				arg0_3.transform:SetParent(arg0_2._workerTf, false)

				local var0_3 = arg0_3:GetComponent(typeof(SpineAnimUI))

				arg0_2.wokerSpine = {
					model = arg0_2.model,
					anim = var0_3,
					name = var0_2
				}

				arg0_2:changeWorkerAction(var19_0, 0, nil)
			end)

			arg0_2.selectedGifts = {}
			arg0_2.gifts = {}
			arg0_2.delegateGifts = {}

			for iter0_2 = 1, #var13_0 do
				local var1_2 = iter0_2
				local var2_2 = findTF(arg0_2._giftTf, var13_0[iter0_2])

				table.insert(arg0_2.gifts, {
					tf = var2_2,
					index = iter0_2
				})

				local var3_2 = GetOrAddComponent(var2_2, "EventTriggerListener")

				var3_2:AddPointDownFunc(function(arg0_4, arg1_4)
					arg0_2:selectGift(var1_2)
				end)
				table.insert(arg0_2.delegateGifts, var3_2)
			end

			arg0_2:updateSelected()
		end,
		changeWorkerAction = function(arg0_5, arg1_5, arg2_5, arg3_5)
			arg0_5.wokerSpine.anim:SetActionCallBack(nil)
			arg0_5.wokerSpine.anim:SetAction(arg1_5, 0)
			arg0_5.wokerSpine.anim:SetActionCallBack(function(arg0_6)
				if arg0_6 == "finish" then
					if arg2_5 == 1 then
						arg0_5.wokerSpine.anim:SetActionCallBack(nil)
						arg0_5.wokerSpine.anim:SetAction(var19_0, 0)
					end

					if arg3_5 then
						arg3_5()
					end
				end
			end)

			if arg2_5 ~= 1 and arg3_5 then
				arg3_5()
			end
		end,
		selectGift = function(arg0_7, arg1_7)
			if table.contains(var14_0, arg1_7) then
				for iter0_7 = #arg0_7.selectedGifts, 1, -1 do
					local var0_7 = arg0_7.selectedGifts[iter0_7]

					if table.contains(var14_0, var0_7) and var0_7 ~= arg1_7 then
						table.remove(arg0_7.selectedGifts, iter0_7)
					end
				end
			elseif #arg0_7.selectedGifts == 2 and not table.contains(arg0_7.selectedGifts, arg1_7) then
				local var1_7 = false

				for iter1_7 = 1, #arg0_7.selectedGifts do
					if table.contains(var14_0, arg0_7.selectedGifts[iter1_7]) then
						var1_7 = true

						break
					end
				end

				if not var1_7 then
					table.remove(arg0_7.selectedGifts, 1)
				end
			end

			local var2_7 = 0

			for iter2_7 = 1, #arg0_7.selectedGifts do
				if arg0_7.selectedGifts[iter2_7] == arg1_7 then
					var2_7 = iter2_7
				end
			end

			if var2_7 == 0 then
				table.insert(arg0_7.selectedGifts, arg1_7)
				arg0_7:moveJiujiu(arg1_7)
				arg0_7:changeWorkerAction(var20_0, 1)
			else
				table.remove(arg0_7.selectedGifts, var2_7)
			end

			if #arg0_7.selectedGifts >= var16_0 then
				arg0_7._event:emit(var11_0, Clone(arg0_7.selectedGifts), function(arg0_8)
					if not arg0_8 then
						arg0_7:changeWorkerAction(var21_0, 1)
					end
				end)

				arg0_7.selectedGifts = {}

				arg0_7:moveJiujiu(-1)
			end

			arg0_7:updateSelected()
		end,
		start = function(arg0_9)
			arg0_9.selectedGifts = {}

			arg0_9:updateSelected()
		end,
		updateSelected = function(arg0_10)
			for iter0_10 = 1, #arg0_10.gifts do
				local var0_10 = arg0_10.gifts[iter0_10].index

				if table.contains(arg0_10.selectedGifts, var0_10) then
					setActive(findTF(arg0_10.gifts[iter0_10].tf, "selected"), true)
				else
					setActive(findTF(arg0_10.gifts[iter0_10].tf, "selected"), false)
				end
			end
		end,
		moveJiujiu = function(arg0_11, arg1_11)
			if arg1_11 == -1 then
				arg0_11._workerTf.anchoredPosition = Vector3.New(-290, 30, 0)
				arg0_11._workerTf.localScale = Vector3.New(-1, 1, 1)
			else
				local var0_11 = arg0_11.gifts[arg1_11].tf
				local var1_11 = arg0_11._workerTf.parent:InverseTransformPoint(var0_11.position)

				var1_11.x = var1_11.x + 150
				var1_11.y = var1_11.y - 50
				arg0_11._workerTf.anchoredPosition = var1_11
				arg0_11._workerTf.localScale = Vector3.New(1, 1, 1)
			end
		end,
		destroy = function(arg0_12)
			if arg0_12.delegateGifts and #arg0_12.delegateGifts > 0 then
				for iter0_12 = 1, #arg0_12.delegateGifts do
					ClearEventTrigger(arg0_12.delegateGifts[iter0_12])
				end

				arg0_12.delegateGifts = {}
			end

			PoolMgr.GetInstance():ReturnSpineChar(arg0_12.wokerSpine.name, arg0_12.wokerSpine.model)
		end
	}

	var0_1:Ctor()

	return var0_1
end

local function var34_0(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = {
		Ctor = function(arg0_14)
			arg0_14._groupTf = arg1_13
			arg0_14._groupIndex = arg2_13
			arg0_14._groupTf.anchoredPosition = var31_0[arg2_13]
			arg0_14._event = arg3_13
			arg0_14.modelData = {}

			SetActive(arg0_14._groupTf, true)
			arg0_14:createIdol(arg0_13[1], arg0_13[2])

			arg0_14.fans = {}
			arg0_14.wantedData = {}
		end,
		createIdol = function(arg0_15, arg1_15, arg2_15)
			local var0_15 = Ship.New({
				configId = arg1_15,
				skin_id = arg2_15
			}):getPrefab()

			PoolMgr.GetInstance():GetSpineChar(var0_15, true, function(arg0_16)
				arg0_16.transform.localScale = Vector3.one
				arg0_16.transform.localPosition = Vector3.zero

				arg0_16.transform:SetParent(findTF(arg0_15._groupTf, "idolPos"), false)

				local var0_16 = arg0_16:GetComponent(typeof(SpineAnimUI))

				arg0_15.modelData = {
					model = arg0_15.model,
					id = arg1_15,
					skinId = arg2_15,
					anim = var0_16
				}

				arg0_15:changeCharAction(var18_0, 0, nil)
			end)
		end,
		changeCharAction = function(arg0_17, arg1_17, arg2_17, arg3_17)
			if arg0_17.modelData.actionName == arg1_17 then
				return
			end

			arg0_17.modelData.actionName = arg1_17

			arg0_17.modelData.anim:SetActionCallBack(nil)
			arg0_17.modelData.anim:SetAction(arg1_17, 0)
			arg0_17.modelData.anim:SetActionCallBack(function(arg0_18)
				if arg0_18 == "finish" then
					if arg2_17 == 1 then
						arg0_17.modelData.anim:SetActionCallBack(nil)
						arg0_17.modelData.anim:SetAction(var18_0, 0)
					end

					if arg3_17 then
						arg3_17()
					end
				end
			end)

			if arg2_17 ~= 1 and arg3_17 then
				arg3_17()
			end
		end,
		createFans = function(arg0_19, arg1_19)
			SetActive(arg1_19, true)
			SetParent(arg1_19, findTF(arg0_19._groupTf, "fansPos"))

			if #arg0_19.fans > 0 then
				local var0_19 = arg0_19.fans[#arg0_19.fans].tf.anchoredPosition

				var0_19.x = var0_19.x + var32_0 + math.random() * 200 + 150
				arg1_19.anchoredPosition = Vector3.New(var0_19.x, var0_19.y, var0_19.z)
			else
				arg1_19.anchoredPosition = Vector3.New((#arg0_19.fans + 1) * var32_0 + 200, 0, 0)
			end

			table.insert(arg0_19.fans, {
				tf = arg1_19,
				speed = math.random() + 2.5
			})

			local var1_19 = arg0_19.fans[#arg0_19.fans]
			local var2_19 = "jiu-fan" .. math.random(1, 4)

			PoolMgr.GetInstance():GetSpineChar(var2_19, true, function(arg0_20)
				arg0_20.transform.localScale = Vector3.one
				arg0_20.transform.localPosition = Vector3.zero

				arg0_20.transform:SetParent(findTF(var1_19.tf, "spinePos"), false)

				local var0_20 = arg0_20:GetComponent(typeof(SpineAnimUI))

				var1_19.modelData = {
					model = arg0_20,
					anim = var0_20,
					modelName = var2_19
				}
			end)
		end,
		changeFansAction = function(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
			if not arg1_21.modelData or arg1_21.modelData.actionName == arg2_21 then
				return
			end

			arg1_21.modelData.actionName = arg2_21

			arg1_21.modelData.anim:SetActionCallBack(nil)
			arg1_21.modelData.anim:SetAction(arg2_21, 0)
			arg1_21.modelData.anim:SetActionCallBack(function(arg0_22)
				if arg0_22 == "finish" then
					if arg3_21 == 1 then
						arg1_21.modelData.anim:SetActionCallBack(nil)
						arg1_21.modelData.anim:SetAction(var25_0, 0)
					end

					if arg4_21 then
						arg4_21()
					end
				end
			end)

			if arg3_21 ~= 1 and arg4_21 then
				arg4_21()
			end
		end,
		getWantedGifts = function(arg0_23)
			if #arg0_23.fans > 0 and arg0_23.fans[1].gifts and not arg0_23.fans[1].leave then
				return arg0_23.fans[1].gifts
			end

			return nil
		end,
		clearFans = function(arg0_24)
			for iter0_24 = 1, #arg0_24.fans do
				PoolMgr.GetInstance():ReturnSpineChar(arg0_24.fans[iter0_24].modelData.modelName, arg0_24.fans[iter0_24].modelData.model)
				Destroy(arg0_24.fans[iter0_24].tf)
			end

			arg0_24.fans = {}
		end,
		start = function(arg0_25)
			return
		end,
		step = function(arg0_26, arg1_26)
			arg0_26.stepTime = arg1_26

			for iter0_26 = #arg0_26.fans, 1, -1 do
				local var0_26 = arg0_26.fans[iter0_26]
				local var1_26 = var0_26.tf
				local var2_26 = var0_26.tf.anchoredPosition

				if var2_26.x > (iter0_26 - 1) * var32_0 then
					var2_26.x = var2_26.x - var0_26.speed
					var0_26.tf.anchoredPosition = var2_26

					arg0_26:changeFansAction(var0_26, var26_0, 0, nil)
				elseif iter0_26 == 1 and not var0_26.leave then
					if var0_26.gifts == nil then
						var0_26.gifts = arg0_26:createWantedGifts()
						var0_26.time = arg1_26 + var7_0

						local var3_26 = LoadSprite("ui/minigameui/idolmasterui_atlas", "pack" .. var0_26.gifts[1])

						setImageSprite(findTF(var0_26.tf, "score/pack"), var3_26)
						arg0_26:changeFansAction(var0_26, var24_0, 0, nil)
					end
				elseif not var0_26.leave then
					arg0_26:changeFansAction(var0_26, var25_0, 0, nil)
				end
			end

			if #arg0_26.fans > 0 then
				local var4_26 = arg0_26.fans[1]

				if var4_26.time and arg1_26 > var4_26.time and not var4_26.leave then
					var4_26.leave = true

					arg0_26:fanLeave(var4_26, var28_0, function()
						table.remove(arg0_26.fans, 1)
					end)
				else
					arg0_26:showFansWanted(var4_26)
				end

				var4_26.tf:SetSiblingIndex(#arg0_26.fans - 1)
			end
		end,
		showFansWanted = function(arg0_28, arg1_28)
			if arg1_28.leave then
				return
			end

			local var0_28 = arg1_28.time

			if not var0_28 then
				return
			end

			local var1_28 = math.ceil(var0_28 - arg0_28.stepTime) < 0 and 0 or var0_28 - arg0_28.stepTime
			local var2_28 = arg1_28.gifts
			local var3_28 = var1_28 <= 5

			setActive(findTF(arg1_28.tf, "wanted"), true)
			setActive(findTF(arg1_28.tf, "wanted/bg1"), not var3_28)
			setActive(findTF(arg1_28.tf, "wanted/bgTime1"), not var3_28)
			setActive(findTF(arg1_28.tf, "wanted/time1"), not var3_28)
			setActive(findTF(arg1_28.tf, "wanted/bg2"), var3_28)
			setActive(findTF(arg1_28.tf, "wanted/bgTime2"), var3_28)
			setActive(findTF(arg1_28.tf, "wanted/time1"), var3_28)

			if var1_28 < 0 then
				var1_28 = 0
			end

			setText(findTF(arg1_28.tf, "wanted/time1"), math.abs(math.ceil(var1_28)) .. "S")
			setText(findTF(arg1_28.tf, "wanted/time2"), math.abs(math.ceil(var1_28)) .. "S")

			for iter0_28 = 1, #var2_28 do
				local var4_28 = LoadSprite("ui/minigameui/idolmasterui_atlas", "wantItem" .. var2_28[iter0_28])

				setImageSprite(findTF(arg1_28.tf, "wanted/item" .. iter0_28), var4_28)
			end
		end,
		checkGifts = function(arg0_29, arg1_29)
			local var0_29 = arg0_29:getWantedGifts()

			if var0_29 then
				for iter0_29 = 1, #arg1_29 do
					if not table.contains(var0_29, arg1_29[iter0_29]) then
						return false
					end
				end

				local var1_29 = arg0_29.fans[1]

				var1_29.leave = true

				arg0_29:fanLeave(var1_29, var29_0, function()
					table.remove(arg0_29.fans, 1)
				end)

				return true
			end

			return false
		end,
		createWantedGifts = function(arg0_31)
			local var0_31 = Clone(var15_0)
			local var1_31 = {}

			table.insert(var1_31, var14_0[math.random(1, #var14_0)])

			for iter0_31 = 1, 2 do
				local var2_31 = table.remove(var0_31, math.random(1, #var0_31))

				table.insert(var1_31, var2_31)
			end

			return var1_31
		end,
		fanLeave = function(arg0_32, arg1_32, arg2_32, arg3_32)
			setActive(findTF(arg1_32.tf, "wanted"), false)

			local var0_32

			if var28_0 == arg2_32 then
				var0_32 = var23_0
			elseif var29_0 then
				var0_32 = var22_0

				setText(findTF(arg1_32.tf, "score"), "+" .. var6_0)
				setActive(findTF(arg1_32.tf, "score"), true)
			end

			arg0_32:changeFansAction(arg1_32, var0_32, 1, function()
				PoolMgr.GetInstance():ReturnSpineChar(arg1_32.modelData.modelName, arg1_32.modelData.model)
				arg0_32._event:emit(var12_0, arg2_32)
				Destroy(arg1_32.tf)
				arg3_32()
			end)
		end,
		reset = function(arg0_34)
			arg0_34:clearFans()

			arg0_34.wantedData = {}
		end,
		destroy = function(arg0_35)
			if arg0_35.modelData then
				PoolMgr.GetInstance():ReturnSpineChar(arg0_35.modelData.id, arg0_35.modelData.model)
			end
		end
	}

	var0_13:Ctor()

	return var0_13
end

local function var35_0(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = {
		Ctor = function(arg0_37)
			arg0_37._containerTf = arg0_36
			arg0_37._tplGroup = arg1_36
			arg0_37._tplIdol = arg2_36
			arg0_37._tplFans = arg3_36
			arg0_37._event = arg4_36
			arg0_37.groups = {}

			local var0_37 = arg0_37:getRandomIdols()

			for iter0_37 = 1, var30_0 do
				local var1_37 = tf(Instantiate(arg0_37._tplGroup))

				SetParent(var1_37, arg0_37._containerTf)

				local var2_37 = var34_0(var0_37[iter0_37], var1_37, iter0_37, arg0_37._event)

				table.insert(arg0_37.groups, var2_37)
			end
		end,
		receiveGift = function(arg0_38, arg1_38, arg2_38)
			local var0_38 = false

			for iter0_38 = 1, #arg0_38.groups do
				if arg0_38.groups[iter0_38]:checkGifts(arg1_38) then
					var0_38 = true

					break
				end
			end

			if arg2_38 then
				arg2_38(var0_38)
			end
		end,
		getRandomIdols = function(arg0_39)
			local var0_39 = {}
			local var1_39 = Clone(var9_0)

			for iter0_39 = 1, var30_0 do
				local var2_39 = false

				if iter0_39 == var30_0 then
					var2_39 = true

					for iter1_39, iter2_39 in ipairs(var10_0) do
						if table.contains(var0_39, iter2_39) then
							var2_39 = false
						end
					end
				end

				if var2_39 then
					table.insert(var0_39, var10_0[math.random(1, #var10_0)])
				else
					table.insert(var0_39, table.remove(var1_39, math.random(1, #var1_39)))
				end
			end

			return var0_39
		end,
		getApearTime = function(arg0_40)
			if arg0_40.runTime and arg0_40.runTime > 0 then
				for iter0_40 = 1, #var8_0 do
					if arg0_40.runTime < var8_0[iter0_40][1] then
						return var8_0[iter0_40][2]
					end
				end
			end

			return var8_0[#var8_0][2]
		end,
		start = function(arg0_41)
			arg0_41:reset()

			arg0_41.createFansTime = nil
			arg0_41.lastTime = var5_0

			for iter0_41 = 1, 3 do
				local var0_41 = math.random(1, #arg0_41.groups)

				arg0_41.groups[var0_41]:createFans(tf(instantiate(arg0_41._tplFans)))
			end

			for iter1_41 = 1, #arg0_41.groups do
				arg0_41.groups[iter1_41]:start()
			end
		end,
		step = function(arg0_42, arg1_42)
			arg0_42.lastTime = arg0_42.lastTime - Time.deltaTime

			local var0_42 = arg0_42:getApearTime()

			if not arg0_42.createFansTime then
				arg0_42.createFansTime = arg1_42 + var0_42 + math.random() * 1
			elseif arg1_42 > arg0_42.createFansTime then
				local var1_42 = math.random(1, #arg0_42.groups)

				arg0_42.groups[var1_42]:createFans(tf(instantiate(arg0_42._tplFans)))

				arg0_42.createFansTime = arg1_42 + var0_42 + math.random() * 1
			end

			for iter0_42 = 1, #arg0_42.groups do
				arg0_42.groups[iter0_42]:step(arg1_42)
			end
		end,
		reset = function(arg0_43)
			for iter0_43 = 1, #arg0_43.groups do
				arg0_43.groups[iter0_43]:reset()
			end
		end,
		destroy = function(arg0_44)
			for iter0_44 = 1, #arg0_44.groups do
				arg0_44.groups[iter0_44]:destroy()
			end
		end
	}

	var0_36:Ctor()

	return var0_36
end

function var0_0.getUIName(arg0_45)
	return "IdolMasterGameUI"
end

function var0_0.getBGM(arg0_46)
	return var1_0
end

function var0_0.didEnter(arg0_47)
	arg0_47:initEvent()
	arg0_47:initData()
	arg0_47:initUI()
	arg0_47:initGameUI()
	arg0_47:updateMenuUI()
	arg0_47:openMenuUI()
end

function var0_0.initEvent(arg0_48)
	arg0_48:bind(var11_0, function(arg0_49, arg1_49, arg2_49)
		if arg0_48.idolGroupUI then
			arg0_48.idolGroupUI:receiveGift(arg1_49, arg2_49)
		end
	end)
	arg0_48:bind(var12_0, function(arg0_50, arg1_50, arg2_50)
		if arg0_48.gameStartFlag then
			if arg1_50 == var28_0 then
				arg0_48:loseHeart()
			elseif arg1_50 == var29_0 then
				arg0_48:addScore(100)
			end
		end
	end)
end

function var0_0.initData(arg0_51)
	local var0_51 = Application.targetFrameRate or 60

	arg0_51.storylist = arg0_51:GetMGHubData():GetSimpleValue("story")
	arg0_51.timer = Timer.New(function()
		arg0_51:onTimer()
	end, 1 / var0_51, -1)
end

function var0_0.initUI(arg0_53)
	arg0_53.sceneTf = findTF(arg0_53._tf, "scene")
	arg0_53.clickMask = findTF(arg0_53._tf, "clickMask")
	arg0_53.countUI = findTF(arg0_53._tf, "pop/CountUI")
	arg0_53.countAnimator = GetComponent(findTF(arg0_53.countUI, "count"), typeof(Animator))
	arg0_53.countDft = GetComponent(findTF(arg0_53.countUI, "count"), typeof(DftAniEvent))

	arg0_53.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_53.countDft:SetEndEvent(function()
		setActive(arg0_53.countUI, false)
		arg0_53:gameStart()
	end)

	arg0_53.leaveUI = findTF(arg0_53._tf, "pop/LeaveUI")

	onButton(arg0_53, findTF(arg0_53.leaveUI, "ad/btnOk"), function()
		arg0_53:resumeGame()
		arg0_53:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_53, findTF(arg0_53.leaveUI, "ad/btnCancel"), function()
		arg0_53:resumeGame()
	end, SFX_CANCEL)

	arg0_53.pauseUI = findTF(arg0_53._tf, "pop/pauseUI")

	onButton(arg0_53, findTF(arg0_53.pauseUI, "ad/btnOk"), function()
		setActive(arg0_53.pauseUI, false)
		arg0_53:resumeGame()
	end, SFX_CANCEL)

	arg0_53.settlementUI = findTF(arg0_53._tf, "pop/SettleMentUI")

	onButton(arg0_53, findTF(arg0_53.settlementUI, "ad/btnOver"), function()
		setActive(arg0_53.settlementUI, false)
		arg0_53:openMenuUI()
	end, SFX_CANCEL)

	arg0_53.menuUI = findTF(arg0_53._tf, "pop/menuUI")
	arg0_53.battleScrollRect = GetComponent(findTF(arg0_53.menuUI, "battList"), typeof(ScrollRect))
	arg0_53.totalTimes = arg0_53:getGameTotalTime()

	local var0_53 = arg0_53:getGameUsedTimes() - 4 < 0 and 0 or arg0_53:getGameUsedTimes() - 4

	scrollTo(arg0_53.battleScrollRect, 0, 1 - var0_53 / (arg0_53.totalTimes - 4))
	onButton(arg0_53, findTF(arg0_53.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_60 = arg0_53.battleScrollRect.normalizedPosition.y + 1 / (arg0_53.totalTimes - 4)

		if var0_60 > 1 then
			var0_60 = 1
		end

		scrollTo(arg0_53.battleScrollRect, 0, var0_60)
	end, SFX_CANCEL)
	onButton(arg0_53, findTF(arg0_53.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_61 = arg0_53.battleScrollRect.normalizedPosition.y - 1 / (arg0_53.totalTimes - 4)

		if var0_61 < 0 then
			var0_61 = 0
		end

		scrollTo(arg0_53.battleScrollRect, 0, var0_61)
	end, SFX_CANCEL)
	onButton(arg0_53, findTF(arg0_53.menuUI, "btnBack"), function()
		arg0_53:closeView()
	end, SFX_CANCEL)
	onButton(arg0_53, findTF(arg0_53.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.cowboy_tips.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_53, findTF(arg0_53.menuUI, "btnStart"), function()
		setActive(arg0_53.menuUI, false)
		arg0_53:readyStart()
	end, SFX_CANCEL)

	local var1_53 = findTF(arg0_53.menuUI, "tplBattleItem")

	arg0_53.battleItems = {}

	for iter0_53 = 1, arg0_53.totalTimes do
		local var2_53 = tf(instantiate(var1_53))

		var2_53.name = "battleItem_" .. iter0_53

		setParent(var2_53, findTF(arg0_53.menuUI, "battList/Viewport/Content"))

		local var3_53 = iter0_53

		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "tx_" .. var3_53, function(arg0_65)
			setImageSprite(findTF(var2_53, "state_open/icon"), arg0_65, true)
			setImageSprite(findTF(var2_53, "state_clear/icon"), arg0_65, true)
			setImageSprite(findTF(var2_53, "state_current/icon"), arg0_65, true)
		end)
		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "battleDesc" .. var3_53, function(arg0_66)
			setImageSprite(findTF(var2_53, "state_open/buttomDesc"), arg0_66, true)
			setImageSprite(findTF(var2_53, "state_clear/buttomDesc"), arg0_66, true)
			setImageSprite(findTF(var2_53, "state_current/buttomDesc"), arg0_66, true)
			setImageSprite(findTF(var2_53, "state_closed/buttomDesc"), arg0_66, true)
		end)
		setActive(var2_53, true)
		table.insert(arg0_53.battleItems, var2_53)
	end

	if not arg0_53.handle then
		arg0_53.handle = UpdateBeat:CreateListener(arg0_53.Update, arg0_53)
	end

	UpdateBeat:AddListener(arg0_53.handle)
end

function var0_0.initGameUI(arg0_67)
	arg0_67.gameUI = findTF(arg0_67._tf, "ui/gameUI")
	arg0_67.textScore = findTF(arg0_67.gameUI, "top/score")

	onButton(arg0_67, findTF(arg0_67.gameUI, "topRight/btnStop"), function()
		arg0_67:stopGame()
		setActive(arg0_67.pauseUI, true)
	end)
	onButton(arg0_67, findTF(arg0_67.gameUI, "btnLeave"), function()
		arg0_67:stopGame()
		setActive(arg0_67.leaveUI, true)
	end)

	arg0_67.gameTimeM = findTF(arg0_67.gameUI, "topRight/time/m")
	arg0_67.gameTimeS = findTF(arg0_67.gameUI, "topRight/time/s")
	arg0_67.heartTfs = {}

	for iter0_67 = 1, var27_0 do
		table.insert(arg0_67.heartTfs, findTF(arg0_67.gameUI, "top/heart" .. iter0_67 .. "/full"))
	end

	arg0_67.scoreTf = findTF(arg0_67.gameUI, "top/score")
	arg0_67.giftUI = var33_0(findTF(arg0_67._tf, "scene/gift"), findTF(arg0_67._tf, "scene/jiujiuWorker"), arg0_67)

	local var0_67 = findTF(arg0_67._tf, "scene/group")
	local var1_67 = findTF(arg0_67._tf, "scene/IdolContainer")
	local var2_67 = findTF(arg0_67._tf, "scene/Idol")
	local var3_67 = findTF(arg0_67._tf, "scene/fans")

	arg0_67.idolGroupUI = var35_0(var1_67, var0_67, var2_67, var3_67, arg0_67)
end

function var0_0.Update(arg0_70)
	arg0_70:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_71)
	if arg0_71.gameStop or arg0_71.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_72)
	local var0_72 = arg0_72:getGameUsedTimes()
	local var1_72 = arg0_72:getGameTimes()

	for iter0_72 = 1, #arg0_72.battleItems do
		setActive(findTF(arg0_72.battleItems[iter0_72], "state_open"), false)
		setActive(findTF(arg0_72.battleItems[iter0_72], "state_closed"), false)
		setActive(findTF(arg0_72.battleItems[iter0_72], "state_clear"), false)
		setActive(findTF(arg0_72.battleItems[iter0_72], "state_current"), false)

		if iter0_72 <= var0_72 then
			setActive(findTF(arg0_72.battleItems[iter0_72], "state_clear"), true)
		elseif iter0_72 == var0_72 + 1 and var1_72 >= 1 then
			setActive(findTF(arg0_72.battleItems[iter0_72], "state_current"), true)
		elseif var0_72 < iter0_72 and iter0_72 <= var0_72 + var1_72 then
			setActive(findTF(arg0_72.battleItems[iter0_72], "state_open"), true)
		else
			setActive(findTF(arg0_72.battleItems[iter0_72], "state_closed"), true)
		end
	end

	arg0_72.totalTimes = arg0_72:getGameTotalTime()

	local var2_72 = 1 - (arg0_72:getGameUsedTimes() - 3 < 0 and 0 or arg0_72:getGameUsedTimes() - 3) / (arg0_72.totalTimes - 4)

	if var2_72 > 1 then
		var2_72 = 1
	end

	scrollTo(arg0_72.battleScrollRect, 0, var2_72)
	setActive(findTF(arg0_72.menuUI, "btnStart/tip"), var1_72 > 0)
	arg0_72:CheckGet()
end

function var0_0.CheckGet(arg0_73)
	setActive(findTF(arg0_73.menuUI, "got"), false)

	if arg0_73:getUltimate() and arg0_73:getUltimate() ~= 0 then
		setActive(findTF(arg0_73.menuUI, "got"), true)
	end

	if arg0_73:getUltimate() == 0 then
		if arg0_73:getGameTotalTime() > arg0_73:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_73:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_73.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_74)
	setActive(findTF(arg0_74._tf, "scene_front"), false)
	setActive(findTF(arg0_74._tf, "scene_background"), false)
	setActive(findTF(arg0_74._tf, "scene"), false)
	setActive(arg0_74.gameUI, false)
	setActive(arg0_74.menuUI, true)
	arg0_74:updateMenuUI()
end

function var0_0.clearUI(arg0_75)
	setActive(arg0_75.sceneTf, false)
	setActive(arg0_75.settlementUI, false)
	setActive(arg0_75.countUI, false)
	setActive(arg0_75.menuUI, false)
	setActive(arg0_75.gameUI, false)
end

function var0_0.readyStart(arg0_76)
	setActive(arg0_76.countUI, true)
	arg0_76.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)
end

function var0_0.gameStart(arg0_77)
	setActive(findTF(arg0_77._tf, "scene_front"), true)
	setActive(findTF(arg0_77._tf, "scene_background"), true)
	setActive(findTF(arg0_77._tf, "scene"), true)
	setActive(arg0_77.gameUI, true)

	arg0_77.gameStartFlag = true
	arg0_77.scoreNum = 0
	arg0_77.playerPosIndex = 2
	arg0_77.gameStepTime = 0
	arg0_77.heart = var27_0
	arg0_77.gameTime = var5_0

	arg0_77.idolGroupUI:start()
	arg0_77.giftUI:start()
	arg0_77:updateGameUI()
	arg0_77:timerStart()
end

function var0_0.getGameTimes(arg0_78)
	return arg0_78:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_79)
	return arg0_79:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_80)
	return arg0_80:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_81)
	return (arg0_81:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_82, arg1_82)
	return
end

function var0_0.onTimer(arg0_83)
	arg0_83:gameStep()
end

function var0_0.gameStep(arg0_84)
	arg0_84.gameTime = arg0_84.gameTime - Time.deltaTime

	if arg0_84.gameTime < 0 then
		arg0_84.gameTime = 0
	end

	arg0_84.gameStepTime = arg0_84.gameStepTime + Time.deltaTime

	if arg0_84.idolGroupUI then
		arg0_84.idolGroupUI:step(arg0_84.gameStepTime)
	end

	arg0_84:updateGameUI()

	if arg0_84.gameTime <= 0 then
		arg0_84:onGameOver()

		return
	end
end

function var0_0.timerStart(arg0_85)
	if not arg0_85.timer.running then
		arg0_85.timer:Start()
	end
end

function var0_0.timerStop(arg0_86)
	if arg0_86.timer.running then
		arg0_86.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_87)
	setText(arg0_87.textScore, arg0_87.scoreNum)

	local var0_87 = math.floor(math.ceil(arg0_87.gameTime) / 60)

	if var0_87 < 10 then
		var0_87 = "0" .. var0_87
	end

	local var1_87 = math.floor(math.ceil(arg0_87.gameTime) % 60)

	if var1_87 < 10 then
		var1_87 = "0" .. var1_87
	end

	for iter0_87 = 1, #arg0_87.heartTfs do
		if iter0_87 <= arg0_87.heart then
			setActive(arg0_87.heartTfs[iter0_87], true)
		else
			setActive(arg0_87.heartTfs[iter0_87], false)
		end
	end

	setText(arg0_87.scoreTf, arg0_87.scoreNum)
	setText(arg0_87.gameTimeM, var0_87)
	setText(arg0_87.gameTimeS, var1_87)
end

function var0_0.loseHeart(arg0_88)
	if arg0_88.heart <= 0 then
		return
	end

	arg0_88.heart = arg0_88.heart - 1

	arg0_88:updateGameUI()

	if arg0_88.heart <= 0 then
		arg0_88.heart = 0

		arg0_88:onGameOver()
	end
end

function var0_0.addScore(arg0_89, arg1_89)
	arg0_89.scoreNum = arg0_89.scoreNum + arg1_89

	if arg0_89.scoreNum < 0 then
		arg0_89.scoreNum = 0
	end
end

function var0_0.onGameOver(arg0_90)
	if arg0_90.settlementFlag then
		return
	end

	arg0_90:timerStop()

	arg0_90.settlementFlag = true

	setActive(arg0_90.clickMask, true)
	LeanTween.delayedCall(go(arg0_90._tf), 2, System.Action(function()
		arg0_90.settlementFlag = false
		arg0_90.gameStartFlag = false

		setActive(arg0_90.clickMask, false)
		arg0_90:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_92)
	setActive(arg0_92.settlementUI, true)
	GetComponent(findTF(arg0_92.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_92 = arg0_92:GetMGData():GetRuntimeData("elements")
	local var1_92 = arg0_92.scoreNum
	local var2_92 = var0_92 and #var0_92 > 0 and var0_92[1] or 0

	setActive(findTF(arg0_92.settlementUI, "ad/new"), var2_92 < var1_92)

	if var2_92 <= var1_92 then
		var2_92 = var1_92

		arg0_92:StoreDataToServer({
			var2_92
		})
	end

	local var3_92 = findTF(arg0_92.settlementUI, "ad/highText")
	local var4_92 = findTF(arg0_92.settlementUI, "ad/currentText")

	setText(var3_92, var2_92)
	setText(var4_92, var1_92)

	if arg0_92:getGameTimes() and arg0_92:getGameTimes() > 0 then
		local var5_92 = arg0_92:getGameUsedTimes() + 1
		local var6_92 = pg.NewStoryMgr.GetInstance()
		local var7_92 = arg0_92.storylist[var5_92] and arg0_92.storylist[var5_92][1] or nil

		if var7_92 and not var6_92:IsPlayed(var7_92) then
			var6_92:Play(var7_92)
		end

		arg0_92.sendSuccessFlag = true

		arg0_92:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_93)
	arg0_93.gameStop = false

	setActive(arg0_93.leaveUI, false)
	arg0_93:changeSpeed(1)
	arg0_93:timerStart()
end

function var0_0.stopGame(arg0_94)
	arg0_94.gameStop = true

	arg0_94:timerStop()
	arg0_94:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_95)
	if not arg0_95.gameStartFlag then
		arg0_95:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_95.settlementFlag then
			return
		end

		if isActive(arg0_95.pauseUI) then
			setActive(arg0_95.pauseUI, false)
		end

		arg0_95:stopGame()
		setActive(arg0_95.leaveUI, true)
	end
end

function var0_0.willExit(arg0_96)
	if arg0_96.handle then
		UpdateBeat:RemoveListener(arg0_96.handle)
	end

	if arg0_96._tf and LeanTween.isTweening(go(arg0_96._tf)) then
		LeanTween.cancel(go(arg0_96._tf))
	end

	if arg0_96.timer and arg0_96.timer.running then
		arg0_96.timer:Stop()
	end

	Time.timeScale = 1
	arg0_96.timer = nil
end

return var0_0
