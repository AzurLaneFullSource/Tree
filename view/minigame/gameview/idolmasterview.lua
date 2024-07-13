local var0_0 = class("IdolMasterView", import("..BaseMiniGameView"))
local var1_0 = {
	"idom-THEIDOLM@STER",
	"idom-GOMYWAY"
}
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = 120
local var4_0 = 100
local var5_0 = 15
local var6_0 = {
	{
		30,
		1
	},
	{
		60,
		1
	},
	{
		90,
		3
	},
	{
		120,
		4
	}
}
local var7_0 = {
	"OUXIANGDASHIRICHANG1",
	"",
	"OUXIANGDASHIRICHANG2",
	"",
	"OUXIANGDASHIRICHANG3",
	"",
	"OUXIANGDASHIRICHANG4"
}
local var8_0 = false
local var9_0 = {
	{
		10700011,
		10700010
	},
	{
		10700021,
		10700020
	},
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
	}
}
local var10_0 = {
	{
		10700061,
		10700060
	},
	{
		10700071,
		10700070
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
local var17_0 = "event_bow"
local var18_0 = "event_hello"
local var19_0 = "event_stand"
local var20_0 = "normal"
local var21_0 = "work"
local var22_0 = "wrong"
local var23_0 = "end1"
local var24_0 = "end2"
local var25_0 = "gift"
local var26_0 = "normal"
local var27_0 = "walk"
local var28_0 = 3
local var29_0 = "type_fans_fail"
local var30_0 = "type_fans_success"
local var31_0 = 4
local var32_0 = {
	Vector3(160, 160),
	Vector3(160, -30),
	Vector3(160, -210),
	Vector3(160, -400)
}
local var33_0 = 200
local var34_0 = "是否继续游戏？"
local var35_0 = "是否退出游戏?"
local var36_0 = "本次得分 :"
local var37_0 = "最高得分 :"
local var38_0 = "分数 :"

local function var39_0(arg0_1, arg1_1, arg2_1)
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
					model = arg0_3,
					anim = var0_3,
					name = var0_2
				}

				arg0_2:changeWorkerAction(var20_0, 0, nil)
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
						arg0_5.wokerSpine.anim:SetAction(var20_0, 0)
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
				arg0_7:changeWorkerAction(var21_0, 1)
			else
				table.remove(arg0_7.selectedGifts, var2_7)
			end

			if #arg0_7.selectedGifts >= var16_0 then
				arg0_7._event:emit(var11_0, Clone(arg0_7.selectedGifts), function(arg0_8, arg1_8)
					if not arg0_8 then
						arg0_7:changeWorkerAction(var22_0, 1)
					else
						arg0_7:changeWorkerAction(var20_0, 0, nil)
					end

					arg0_7:moveJiujiu(-1, arg1_8)
				end)

				arg0_7.selectedGifts = {}
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
		moveJiujiu = function(arg0_11, arg1_11, arg2_11)
			if arg1_11 == -1 then
				arg0_11._workerTf.localScale = Vector3.New(-1, 1, 1)

				if arg2_11 and arg2_11 > 0 then
					local var0_11 = Clone(var32_0[arg2_11])

					var0_11.x = -100
					arg0_11._workerTf.anchoredPosition = var0_11
				else
					arg0_11._workerTf.anchoredPosition = Vector3.New(-290, 30, 0)
				end
			else
				local var1_11 = arg0_11.gifts[arg1_11].tf
				local var2_11 = arg0_11._workerTf.parent:InverseTransformPoint(var1_11.position)

				var2_11.x = var2_11.x + 150
				var2_11.y = var2_11.y - 50
				arg0_11._workerTf.anchoredPosition = var2_11
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

local function var40_0(arg0_13, arg1_13, arg2_13)
	local var0_13 = {
		Ctor = function(arg0_14)
			arg0_14._groupTf = arg0_13
			arg0_14._groupIndex = arg1_13
			arg0_14._groupTf.anchoredPosition = var32_0[arg1_13]
			arg0_14._event = arg2_13
			arg0_14.modelData = {}

			SetActive(arg0_14._groupTf, true)

			arg0_14.fans = {}
			arg0_14.wantedData = {}
		end,
		createIdol = function(arg0_15, arg1_15, arg2_15)
			if arg0_15.modelData.model then
				PoolMgr.GetInstance():ReturnSpineChar(arg0_15.modelData.id, arg0_15.modelData.model)
			end

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
					model = arg0_16,
					id = arg1_15,
					skinId = arg2_15,
					anim = var0_16
				}

				arg0_15:changeCharAction(var19_0, 0, nil)
			end)
		end,
		getFansAmount = function(arg0_17)
			return #arg0_17.fans
		end,
		changeCharAction = function(arg0_18, arg1_18, arg2_18, arg3_18)
			if arg0_18.modelData.actionName == arg1_18 then
				return
			end

			arg0_18.modelData.actionName = arg1_18

			arg0_18.modelData.anim:SetActionCallBack(nil)
			arg0_18.modelData.anim:SetAction(arg1_18, 0)
			arg0_18.modelData.anim:SetActionCallBack(function(arg0_19)
				if arg0_19 == "finish" then
					if arg2_18 == 1 then
						arg0_18.modelData.anim:SetActionCallBack(nil)
						arg0_18.modelData.anim:SetAction(var19_0, 0)
					end

					if arg3_18 then
						arg3_18()
					end
				end
			end)

			if arg2_18 ~= 1 and arg3_18 then
				arg3_18()
			end
		end,
		createFans = function(arg0_20, arg1_20)
			SetActive(arg1_20, true)
			SetParent(arg1_20, findTF(arg0_20._groupTf, "fansPos"))

			if #arg0_20.fans > 0 then
				local var0_20 = arg0_20.fans[#arg0_20.fans].tf.anchoredPosition

				var0_20.x = var0_20.x + var33_0 + math.random() * 200 + 150
				arg1_20.anchoredPosition = Vector3.New(var0_20.x, var0_20.y, var0_20.z)
			else
				arg1_20.anchoredPosition = Vector3.New((#arg0_20.fans + 1) * var33_0 + 200, 0, 0)
			end

			setActive(findTF(arg1_20, "wanted"), false)
			table.insert(arg0_20.fans, {
				tf = arg1_20,
				speed = math.random() * 50 + 200
			})

			local var1_20 = arg0_20.fans[#arg0_20.fans]
			local var2_20 = "jiu-fan" .. math.random(1, 4)

			PoolMgr.GetInstance():GetSpineChar(var2_20, true, function(arg0_21)
				arg0_21.transform.localScale = Vector3.one
				arg0_21.transform.localPosition = Vector3.zero

				arg0_21.transform:SetParent(findTF(var1_20.tf, "spinePos"), false)

				local var0_21 = arg0_21:GetComponent(typeof(SpineAnimUI))

				var1_20.modelData = {
					model = arg0_21,
					anim = var0_21,
					modelName = var2_20
				}
			end)
		end,
		changeFansAction = function(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
			if not arg1_22.modelData or arg1_22.modelData.actionName == arg2_22 then
				return
			end

			arg1_22.modelData.actionName = arg2_22

			arg1_22.modelData.anim:SetActionCallBack(nil)
			arg1_22.modelData.anim:SetAction(arg2_22, 0)
			arg1_22.modelData.anim:SetActionCallBack(function(arg0_23)
				if arg0_23 == "finish" then
					if arg3_22 == 1 then
						arg1_22.modelData.anim:SetActionCallBack(nil)
						arg1_22.modelData.anim:SetAction(var26_0, 0)
					end

					if arg4_22 then
						arg4_22()
					end
				end
			end)

			if arg3_22 ~= 1 and arg4_22 then
				arg4_22()
			end
		end,
		getWantedGifts = function(arg0_24)
			if #arg0_24.fans > 0 and arg0_24.fans[1].gifts and not arg0_24.fans[1].leave then
				return arg0_24.fans[1].gifts
			end

			return nil
		end,
		clearFans = function(arg0_25)
			for iter0_25 = 1, #arg0_25.fans do
				PoolMgr.GetInstance():ReturnSpineChar(arg0_25.fans[iter0_25].modelData.modelName, arg0_25.fans[iter0_25].modelData.model)
				Destroy(arg0_25.fans[iter0_25].tf)
			end

			arg0_25.fans = {}
		end,
		start = function(arg0_26)
			return
		end,
		step = function(arg0_27, arg1_27)
			arg0_27.stepTime = arg1_27

			for iter0_27 = #arg0_27.fans, 1, -1 do
				local var0_27 = arg0_27.fans[iter0_27]
				local var1_27 = var0_27.tf
				local var2_27 = var0_27.tf.anchoredPosition

				if var2_27.x > (iter0_27 - 1) * var33_0 then
					var2_27.x = var2_27.x - var0_27.speed * Time.deltaTime
					var0_27.tf.anchoredPosition = var2_27

					arg0_27:changeFansAction(var0_27, var27_0, 0, nil)
				elseif iter0_27 == 1 and not var0_27.leave then
					if var0_27.gifts == nil then
						var0_27.gifts = arg0_27:createWantedGifts()
						var0_27.time = arg1_27 + var5_0

						local var3_27 = LoadSprite("ui/minigameui/idolmasterui_atlas", "pack" .. var0_27.gifts[1])

						setImageSprite(findTF(var0_27.tf, "score/pack"), var3_27)
						arg0_27:changeFansAction(var0_27, var25_0, 0, nil)
						arg0_27:changeCharAction(var18_0, 1, function()
							arg0_27:changeCharAction(var19_0, 0, nil)
						end)
					end
				elseif not var0_27.leave then
					arg0_27:changeFansAction(var0_27, var26_0, 0, nil)
				end
			end

			if #arg0_27.fans > 0 then
				local var4_27 = arg0_27.fans[1]

				if var4_27.time and arg1_27 > var4_27.time and not var4_27.leave then
					var4_27.leave = true

					arg0_27:fanLeave(var4_27, var29_0, function()
						table.remove(arg0_27.fans, 1)
					end)
				else
					arg0_27:showFansWanted(var4_27)
				end

				var4_27.tf:SetSiblingIndex(#arg0_27.fans - 1)
			end
		end,
		showFansWanted = function(arg0_30, arg1_30)
			if arg1_30.leave then
				return
			end

			local var0_30 = arg1_30.time

			if not var0_30 then
				return
			end

			local var1_30 = math.ceil(var0_30 - arg0_30.stepTime) < 0 and 0 or var0_30 - arg0_30.stepTime
			local var2_30 = arg1_30.gifts
			local var3_30 = var1_30 <= 5

			setActive(findTF(arg1_30.tf, "wanted"), true)
			setActive(findTF(arg1_30.tf, "wanted/bg1"), not var3_30)
			setActive(findTF(arg1_30.tf, "wanted/bgTime1"), not var3_30)
			setActive(findTF(arg1_30.tf, "wanted/time1"), not var3_30)
			setActive(findTF(arg1_30.tf, "wanted/bg2"), var3_30)
			setActive(findTF(arg1_30.tf, "wanted/bgTime2"), var3_30)
			setActive(findTF(arg1_30.tf, "wanted/time2"), var3_30)

			if var1_30 < 0 then
				var1_30 = 0
			end

			setText(findTF(arg1_30.tf, "wanted/time1"), math.abs(math.ceil(var1_30)) .. "S")
			setText(findTF(arg1_30.tf, "wanted/time2"), math.abs(math.ceil(var1_30)) .. "S")

			for iter0_30 = 1, #var2_30 do
				local var4_30 = LoadSprite("ui/minigameui/idolmasterui_atlas", "wantItem" .. var2_30[iter0_30])

				setImageSprite(findTF(arg1_30.tf, "wanted/item" .. iter0_30), var4_30, true)
			end
		end,
		checkGifts = function(arg0_31, arg1_31)
			local var0_31 = arg0_31:getWantedGifts()

			if var0_31 then
				for iter0_31 = 1, #arg1_31 do
					if not table.contains(var0_31, arg1_31[iter0_31]) then
						return false
					end
				end

				return true
			end

			return false
		end,
		getGiftTime = function(arg0_32)
			if #arg0_32.fans > 0 and arg0_32.fans[1] and arg0_32.fans[1].time then
				return arg0_32.fans[1].time
			end

			return nil
		end,
		finishGift = function(arg0_33)
			if arg0_33:getWantedGifts() then
				local var0_33 = arg0_33.fans[1]

				var0_33.leave = true

				arg0_33:fanLeave(var0_33, var30_0, function()
					table.remove(arg0_33.fans, 1)
				end)
				arg0_33:changeCharAction(var17_0, 1, function()
					arg0_33:changeCharAction(var19_0, 0, nil)
				end)
			end
		end,
		createWantedGifts = function(arg0_36)
			local var0_36 = Clone(var15_0)
			local var1_36 = {}

			table.insert(var1_36, var14_0[math.random(1, #var14_0)])

			for iter0_36 = 1, 2 do
				local var2_36 = table.remove(var0_36, math.random(1, #var0_36))

				table.insert(var1_36, var2_36)
			end

			return var1_36
		end,
		fanLeave = function(arg0_37, arg1_37, arg2_37, arg3_37)
			setActive(findTF(arg1_37.tf, "wanted"), false)

			local var0_37

			if var29_0 == arg2_37 then
				var0_37 = var24_0
			elseif var30_0 then
				var0_37 = var23_0

				setText(findTF(arg1_37.tf, "score"), "+" .. var4_0)
				setActive(findTF(arg1_37.tf, "score"), true)
			end

			arg0_37:changeFansAction(arg1_37, var0_37, 1, function()
				PoolMgr.GetInstance():ReturnSpineChar(arg1_37.modelData.modelName, arg1_37.modelData.model)
				arg0_37._event:emit(var12_0, arg2_37)
				Destroy(arg1_37.tf)
				arg3_37()
			end)
		end,
		reset = function(arg0_39)
			arg0_39:clearFans()

			arg0_39.wantedData = {}
		end,
		destroy = function(arg0_40)
			if arg0_40.modelData then
				PoolMgr.GetInstance():ReturnSpineChar(arg0_40.modelData.id, arg0_40.modelData.model)
			end
		end
	}

	var0_13:Ctor()

	return var0_13
end

local function var41_0(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	local var0_41 = {
		Ctor = function(arg0_42)
			arg0_42._containerTf = arg0_41
			arg0_42._tplGroup = arg1_41
			arg0_42._tplIdol = arg2_41
			arg0_42._tplFans = arg3_41
			arg0_42._event = arg4_41
			arg0_42.groups = {}

			for iter0_42 = 1, var31_0 do
				local var0_42 = tf(Instantiate(arg0_42._tplGroup))

				SetParent(var0_42, arg0_42._containerTf)

				local var1_42 = var40_0(var0_42, iter0_42, arg0_42._event)

				table.insert(arg0_42.groups, var1_42)
			end
		end,
		createIdols = function(arg0_43)
			local var0_43 = arg0_43:getRandomIdols()

			for iter0_43 = 1, #arg0_43.groups do
				arg0_43.groups[iter0_43]:createIdol(var0_43[iter0_43][1], var0_43[iter0_43][2])
			end
		end,
		receiveGift = function(arg0_44, arg1_44, arg2_44)
			local var0_44 = false
			local var1_44
			local var2_44

			for iter0_44 = 1, #arg0_44.groups do
				if arg0_44.groups[iter0_44]:checkGifts(arg1_44) then
					var0_44 = true

					if not var1_44 then
						var1_44 = arg0_44.groups[iter0_44]
						var2_44 = iter0_44
					elseif var1_44:getGiftTime() > arg0_44.groups[iter0_44]:getGiftTime() then
						var1_44 = arg0_44.groups[iter0_44]
						var2_44 = iter0_44
					end
				end
			end

			if var1_44 then
				var1_44:finishGift()
			end

			if arg2_44 then
				arg2_44(var0_44, var2_44)
			end
		end,
		getRandomIdols = function(arg0_45)
			local var0_45 = {}
			local var1_45 = Clone(var9_0)

			if math.random() > 0.6 then
				var0_45 = Clone(var10_0)
			end

			for iter0_45 = #var0_45 + 1, var31_0 do
				table.insert(var0_45, table.remove(var1_45, math.random(1, #var1_45)))
			end

			local var2_45 = {}

			for iter1_45 = 1, var31_0 do
				table.insert(var2_45, table.remove(var0_45, math.random(1, #var0_45)))
			end

			return var2_45
		end,
		getApearTime = function(arg0_46)
			if arg0_46.lastTime and arg0_46.lastTime > 0 then
				for iter0_46 = 1, #var6_0 do
					if arg0_46.lastTime < var6_0[iter0_46][1] then
						return var6_0[iter0_46][2]
					end
				end
			end

			return var6_0[#var6_0][2]
		end,
		getFansAmount = function(arg0_47)
			local var0_47 = 0

			for iter0_47 = 1, #arg0_47.groups do
				var0_47 = var0_47 + arg0_47.groups[iter0_47]:getFansAmount()
			end

			return var0_47
		end,
		start = function(arg0_48)
			arg0_48:reset()

			arg0_48.createFansTime = nil
			arg0_48.lastTime = var3_0

			for iter0_48 = 1, 3 do
				local var0_48 = math.random(1, #arg0_48.groups)

				arg0_48.groups[var0_48]:createFans(tf(instantiate(arg0_48._tplFans)))
			end

			for iter1_48 = 1, #arg0_48.groups do
				arg0_48.groups[iter1_48]:start()
			end
		end,
		step = function(arg0_49, arg1_49)
			arg0_49.lastTime = arg0_49.lastTime - Time.deltaTime

			if not arg0_49.createFansTime then
				arg0_49.createFansTime = arg1_49 + arg0_49:getApearTime() + math.random() * 1
			elseif arg1_49 > arg0_49.createFansTime and arg0_49:getFansAmount() <= 10 then
				local var0_49 = arg0_49:getApearTime()
				local var1_49 = math.random(1, #arg0_49.groups)

				arg0_49.groups[var1_49]:createFans(tf(instantiate(arg0_49._tplFans)))

				arg0_49.createFansTime = arg1_49 + var0_49 + math.random() * 1
			end

			for iter0_49 = 1, #arg0_49.groups do
				arg0_49.groups[iter0_49]:step(arg1_49)
			end
		end,
		reset = function(arg0_50)
			for iter0_50 = 1, #arg0_50.groups do
				arg0_50.groups[iter0_50]:reset()
			end
		end,
		destroy = function(arg0_51)
			for iter0_51 = 1, #arg0_51.groups do
				arg0_51.groups[iter0_51]:destroy()
			end
		end
	}

	var0_41:Ctor()

	return var0_41
end

function var0_0.getUIName(arg0_52)
	return "IdolMasterGameUI"
end

function var0_0.getBGM(arg0_53)
	return var1_0[math.random(1, #var1_0)]
end

function var0_0.didEnter(arg0_54)
	arg0_54:initEvent()
	arg0_54:initData()
	arg0_54:initUI()
	arg0_54:initGameUI()
	arg0_54:initTextTip()
	arg0_54:updateMenuUI()
	arg0_54:openMenuUI()
end

function var0_0.initEvent(arg0_55)
	arg0_55:bind(var11_0, function(arg0_56, arg1_56, arg2_56)
		if arg0_55.idolGroupUI then
			arg0_55.idolGroupUI:receiveGift(arg1_56, arg2_56)
		end
	end)
	arg0_55:bind(var12_0, function(arg0_57, arg1_57, arg2_57)
		if arg0_55.gameStartFlag then
			if arg1_57 == var29_0 then
				arg0_55:loseHeart()
			elseif arg1_57 == var30_0 then
				arg0_55:addScore(100)
			end
		end
	end)
end

function var0_0.initData(arg0_58)
	local var0_58 = Application.targetFrameRate or 60

	arg0_58.timer = Timer.New(function()
		arg0_58:onTimer()
	end, 1 / var0_58, -1)
end

function var0_0.initUI(arg0_60)
	arg0_60.sceneTf = findTF(arg0_60._tf, "scene")
	arg0_60.clickMask = findTF(arg0_60._tf, "clickMask")
	arg0_60.countUI = findTF(arg0_60._tf, "pop/CountUI")
	arg0_60.countAnimator = GetComponent(findTF(arg0_60.countUI, "count"), typeof(Animator))
	arg0_60.countDft = GetComponent(findTF(arg0_60.countUI, "count"), typeof(DftAniEvent))

	arg0_60.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_60.countDft:SetEndEvent(function()
		setActive(arg0_60.countUI, false)
		arg0_60:gameStart()
	end)

	arg0_60.leaveUI = findTF(arg0_60._tf, "pop/LeaveUI")

	onButton(arg0_60, findTF(arg0_60.leaveUI, "ad/btnOk"), function()
		arg0_60:resumeGame()
		arg0_60:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_60, findTF(arg0_60.leaveUI, "ad/btnCancel"), function()
		arg0_60:resumeGame()
	end, SFX_CANCEL)

	arg0_60.pauseUI = findTF(arg0_60._tf, "pop/pauseUI")

	onButton(arg0_60, findTF(arg0_60.pauseUI, "ad/btnOk"), function()
		setActive(arg0_60.pauseUI, false)
		arg0_60:resumeGame()
	end, SFX_CANCEL)

	arg0_60.settlementUI = findTF(arg0_60._tf, "pop/SettleMentUI")

	onButton(arg0_60, findTF(arg0_60.settlementUI, "ad/btnOver"), function()
		setActive(arg0_60.settlementUI, false)
		arg0_60:openMenuUI()
	end, SFX_CANCEL)

	arg0_60.menuUI = findTF(arg0_60._tf, "pop/menuUI")
	arg0_60.battleScrollRect = GetComponent(findTF(arg0_60.menuUI, "battList"), typeof(ScrollRect))
	arg0_60.totalTimes = arg0_60:getGameTotalTime()

	local var0_60 = arg0_60:getGameUsedTimes() - 4 < 0 and 0 or arg0_60:getGameUsedTimes() - 4

	scrollTo(arg0_60.battleScrollRect, 0, 1 - var0_60 / (arg0_60.totalTimes - 4))
	onButton(arg0_60, findTF(arg0_60.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_67 = arg0_60.battleScrollRect.normalizedPosition.y + 1 / (arg0_60.totalTimes - 4)

		if var0_67 > 1 then
			var0_67 = 1
		end

		scrollTo(arg0_60.battleScrollRect, 0, var0_67)
	end, SFX_CANCEL)
	onButton(arg0_60, findTF(arg0_60.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_68 = arg0_60.battleScrollRect.normalizedPosition.y - 1 / (arg0_60.totalTimes - 4)

		if var0_68 < 0 then
			var0_68 = 0
		end

		scrollTo(arg0_60.battleScrollRect, 0, var0_68)
	end, SFX_CANCEL)
	onButton(arg0_60, findTF(arg0_60.menuUI, "btnBack"), function()
		arg0_60:closeView()
	end, SFX_CANCEL)
	onButton(arg0_60, findTF(arg0_60.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.handshake_game_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_60, findTF(arg0_60.menuUI, "btnStart"), function()
		if arg0_60:getGameUsedTimes() == 0 and not var8_0 then
			var8_0 = true

			setActive(arg0_60.helpUI, true)
		else
			setActive(arg0_60.menuUI, false)
			arg0_60:readyStart()
		end
	end, SFX_CANCEL)

	local var1_60 = findTF(arg0_60.menuUI, "tplBattleItem")

	arg0_60.battleItems = {}

	for iter0_60 = 1, arg0_60.totalTimes do
		local var2_60 = tf(instantiate(var1_60))

		var2_60.name = "battleItem_" .. iter0_60

		setParent(var2_60, findTF(arg0_60.menuUI, "battList/Viewport/Content"))

		local var3_60 = iter0_60

		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "tx_" .. var3_60, function(arg0_72)
			setImageSprite(findTF(var2_60, "state_open/icon"), arg0_72, true)
			setImageSprite(findTF(var2_60, "state_clear/icon"), arg0_72, true)
			setImageSprite(findTF(var2_60, "state_current/icon"), arg0_72, true)
		end)
		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "battleDesc" .. var3_60, function(arg0_73)
			setImageSprite(findTF(var2_60, "state_open/buttomDesc"), arg0_73, true)
			setImageSprite(findTF(var2_60, "state_clear/buttomDesc"), arg0_73, true)
			setImageSprite(findTF(var2_60, "state_current/buttomDesc"), arg0_73, true)
			setImageSprite(findTF(var2_60, "state_closed/buttomDesc"), arg0_73, true)
		end)
		setActive(var2_60, true)
		table.insert(arg0_60.battleItems, var2_60)
	end

	arg0_60.helpUI = findTF(arg0_60._tf, "pop/HelpUI")

	onButton(arg0_60, findTF(arg0_60.helpUI, "close"), function()
		setActive(arg0_60.helpUI, false)
		setActive(arg0_60.menuUI, false)
		arg0_60:readyStart()
	end, SFX_CANCEL)

	if not arg0_60.handle then
		arg0_60.handle = UpdateBeat:CreateListener(arg0_60.Update, arg0_60)
	end

	UpdateBeat:AddListener(arg0_60.handle)
end

function var0_0.initGameUI(arg0_75)
	arg0_75.gameUI = findTF(arg0_75._tf, "ui/gameUI")
	arg0_75.textScore = findTF(arg0_75.gameUI, "top/score")

	onButton(arg0_75, findTF(arg0_75.gameUI, "topRight/btnStop"), function()
		arg0_75:stopGame()
		setActive(arg0_75.pauseUI, true)
	end)
	onButton(arg0_75, findTF(arg0_75.gameUI, "btnLeave"), function()
		arg0_75:stopGame()
		setActive(arg0_75.leaveUI, true)
	end)

	arg0_75.gameTimeM = findTF(arg0_75.gameUI, "topRight/time/m")
	arg0_75.gameTimeS = findTF(arg0_75.gameUI, "topRight/time/s")
	arg0_75.heartTfs = {}

	for iter0_75 = 1, var28_0 do
		table.insert(arg0_75.heartTfs, findTF(arg0_75.gameUI, "top/heart" .. iter0_75 .. "/full"))
	end

	arg0_75.scoreTf = findTF(arg0_75.gameUI, "top/score")
	arg0_75.giftUI = var39_0(findTF(arg0_75._tf, "scene/gift"), findTF(arg0_75._tf, "scene/jiujiuWorker"), arg0_75)

	local var0_75 = findTF(arg0_75._tf, "scene/group")
	local var1_75 = findTF(arg0_75._tf, "scene/IdolContainer")
	local var2_75 = findTF(arg0_75._tf, "scene/Idol")
	local var3_75 = findTF(arg0_75._tf, "scene/fans")

	arg0_75.idolGroupUI = var41_0(var1_75, var0_75, var2_75, var3_75, arg0_75)
end

function var0_0.initTextTip(arg0_78)
	var34_0 = i18n("idolmaster_game_tip1") or var34_0
	var35_0 = i18n("idolmaster_game_tip2") or var35_0
	var36_0 = i18n("idolmaster_game_tip3") or var36_0
	var37_0 = i18n("idolmaster_game_tip4") or var37_0
	var38_0 = i18n("idolmaster_game_tip5") or var38_0

	setText(findTF(arg0_78.settlementUI, "ad/currentTextDesc"), var36_0)
	setText(findTF(arg0_78.settlementUI, "ad/highTextDesc"), var37_0)
	setText(findTF(arg0_78.gameUI, "top/scoreImg/socre"), var38_0)
	setText(findTF(arg0_78.pauseUI, "ad/tip"), var34_0)
	setText(findTF(arg0_78.leaveUI, "ad/tip"), var35_0)
end

function var0_0.Update(arg0_79)
	arg0_79:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_80)
	if arg0_80.gameStop or arg0_80.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_81)
	local var0_81 = arg0_81:getGameUsedTimes()
	local var1_81 = arg0_81:getGameTimes()

	for iter0_81 = 1, #arg0_81.battleItems do
		setActive(findTF(arg0_81.battleItems[iter0_81], "state_open"), false)
		setActive(findTF(arg0_81.battleItems[iter0_81], "state_closed"), false)
		setActive(findTF(arg0_81.battleItems[iter0_81], "state_clear"), false)
		setActive(findTF(arg0_81.battleItems[iter0_81], "state_current"), false)

		if iter0_81 <= var0_81 then
			setActive(findTF(arg0_81.battleItems[iter0_81], "state_clear"), true)
		elseif iter0_81 == var0_81 + 1 and var1_81 >= 1 then
			setActive(findTF(arg0_81.battleItems[iter0_81], "state_current"), true)
		elseif var0_81 < iter0_81 and iter0_81 <= var0_81 + var1_81 then
			setActive(findTF(arg0_81.battleItems[iter0_81], "state_open"), true)
		else
			setActive(findTF(arg0_81.battleItems[iter0_81], "state_closed"), true)
		end
	end

	arg0_81.totalTimes = arg0_81:getGameTotalTime()

	local var2_81 = 1 - (arg0_81:getGameUsedTimes() - 3 < 0 and 0 or arg0_81:getGameUsedTimes() - 3) / (arg0_81.totalTimes - 4)

	if var2_81 > 1 then
		var2_81 = 1
	end

	scrollTo(arg0_81.battleScrollRect, 0, var2_81)
	setActive(findTF(arg0_81.menuUI, "btnStart/tip"), var1_81 > 0)
	arg0_81:CheckGet()
end

function var0_0.CheckGet(arg0_82)
	setActive(findTF(arg0_82.menuUI, "got"), false)

	if arg0_82:getUltimate() and arg0_82:getUltimate() ~= 0 then
		setActive(findTF(arg0_82.menuUI, "got"), true)
	end

	if arg0_82:getUltimate() == 0 then
		if arg0_82:getGameTotalTime() > arg0_82:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_82:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_82.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_83)
	setActive(findTF(arg0_83._tf, "scene_front"), false)
	setActive(findTF(arg0_83._tf, "scene_background"), false)
	setActive(findTF(arg0_83._tf, "scene"), false)
	setActive(arg0_83.gameUI, false)
	setActive(arg0_83.menuUI, true)

	if arg0_83.storyIndex and var7_0[arg0_83.storyIndex] ~= "" and arg0_83:getGameUsedTimes() == arg0_83.storyIndex then
		pg.NewStoryMgr.GetInstance():Play(var7_0[arg0_83.storyIndex], function()
			return
		end, true)

		arg0_83.storyIndex = nil
	end

	arg0_83:updateMenuUI()
end

function var0_0.clearUI(arg0_85)
	setActive(arg0_85.sceneTf, false)
	setActive(arg0_85.settlementUI, false)
	setActive(arg0_85.countUI, false)
	setActive(arg0_85.menuUI, false)
	setActive(arg0_85.gameUI, false)
end

function var0_0.readyStart(arg0_86)
	setActive(arg0_86.countUI, true)
	arg0_86.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)
	arg0_86.idolGroupUI:createIdols()
end

function var0_0.gameStart(arg0_87)
	setActive(findTF(arg0_87._tf, "scene_front"), true)
	setActive(findTF(arg0_87._tf, "scene_background"), true)
	setActive(findTF(arg0_87._tf, "scene"), true)
	setActive(arg0_87.gameUI, true)

	arg0_87.gameStartFlag = true
	arg0_87.scoreNum = 0
	arg0_87.playerPosIndex = 2
	arg0_87.gameStepTime = 0
	arg0_87.heart = var28_0
	arg0_87.gameTime = var3_0

	arg0_87.idolGroupUI:start()
	arg0_87.giftUI:start()
	arg0_87:updateGameUI()
	arg0_87:timerStart()
end

function var0_0.getGameTimes(arg0_88)
	return arg0_88:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_89)
	return arg0_89:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_90)
	return arg0_90:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_91)
	return (arg0_91:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_92, arg1_92)
	return
end

function var0_0.onTimer(arg0_93)
	arg0_93:gameStep()
end

function var0_0.gameStep(arg0_94)
	arg0_94.gameTime = arg0_94.gameTime - Time.deltaTime

	if arg0_94.gameTime < 0 then
		arg0_94.gameTime = 0
	end

	arg0_94.gameStepTime = arg0_94.gameStepTime + Time.deltaTime

	if arg0_94.idolGroupUI then
		arg0_94.idolGroupUI:step(arg0_94.gameStepTime)
	end

	arg0_94:updateGameUI()

	if arg0_94.gameTime <= 0 then
		arg0_94:onGameOver()

		return
	end
end

function var0_0.timerStart(arg0_95)
	if not arg0_95.timer.running then
		arg0_95.timer:Start()
	end
end

function var0_0.timerStop(arg0_96)
	if arg0_96.timer.running then
		arg0_96.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_97)
	setText(arg0_97.textScore, arg0_97.scoreNum)

	local var0_97 = math.floor(math.ceil(arg0_97.gameTime) / 60)

	if var0_97 < 10 then
		var0_97 = "0" .. var0_97
	end

	local var1_97 = math.floor(math.ceil(arg0_97.gameTime) % 60)

	if var1_97 < 10 then
		var1_97 = "0" .. var1_97
	end

	for iter0_97 = 1, #arg0_97.heartTfs do
		if iter0_97 <= arg0_97.heart then
			setActive(arg0_97.heartTfs[iter0_97], true)
		else
			setActive(arg0_97.heartTfs[iter0_97], false)
		end
	end

	setText(arg0_97.scoreTf, arg0_97.scoreNum)
	setText(arg0_97.gameTimeM, var0_97)
	setText(arg0_97.gameTimeS, var1_97)
end

function var0_0.loseHeart(arg0_98)
	if arg0_98.heart <= 0 then
		return
	end

	arg0_98.heart = arg0_98.heart - 1

	arg0_98:updateGameUI()

	if arg0_98.heart <= 0 then
		arg0_98.heart = 0

		arg0_98:onGameOver()
	end
end

function var0_0.addScore(arg0_99, arg1_99)
	arg0_99.scoreNum = arg0_99.scoreNum + arg1_99

	if arg0_99.scoreNum < 0 then
		arg0_99.scoreNum = 0
	end
end

function var0_0.onGameOver(arg0_100)
	if arg0_100.settlementFlag then
		return
	end

	arg0_100:timerStop()

	arg0_100.settlementFlag = true

	setActive(arg0_100.clickMask, true)
	LeanTween.delayedCall(go(arg0_100._tf), 2, System.Action(function()
		arg0_100.settlementFlag = false
		arg0_100.gameStartFlag = false

		setActive(arg0_100.clickMask, false)
		arg0_100:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_102)
	setActive(arg0_102.settlementUI, true)
	GetComponent(findTF(arg0_102.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_102 = arg0_102:GetMGData():GetRuntimeData("elements")
	local var1_102 = arg0_102.scoreNum
	local var2_102 = var0_102 and #var0_102 > 0 and var0_102[1] or 0

	setActive(findTF(arg0_102.settlementUI, "ad/new"), var2_102 < var1_102)

	if var2_102 <= var1_102 then
		var2_102 = var1_102

		arg0_102:StoreDataToServer({
			var2_102
		})
	end

	local var3_102 = findTF(arg0_102.settlementUI, "ad/highText")
	local var4_102 = findTF(arg0_102.settlementUI, "ad/currentText")

	setText(var3_102, var2_102)
	setText(var4_102, var1_102)

	if arg0_102:getGameTimes() and arg0_102:getGameTimes() > 0 then
		arg0_102.sendSuccessFlag = true
		arg0_102.storyIndex = arg0_102:getGameUsedTimes() + 1

		arg0_102:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_103)
	arg0_103.gameStop = false

	setActive(arg0_103.leaveUI, false)
	arg0_103:changeSpeed(1)
	arg0_103:timerStart()
end

function var0_0.stopGame(arg0_104)
	arg0_104.gameStop = true

	arg0_104:timerStop()
	arg0_104:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_105)
	if not arg0_105.gameStartFlag then
		arg0_105:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_105.settlementFlag then
			return
		end

		if isActive(arg0_105.pauseUI) then
			setActive(arg0_105.pauseUI, false)
		end

		arg0_105:stopGame()
		setActive(arg0_105.leaveUI, true)
	end
end

function var0_0.willExit(arg0_106)
	if arg0_106.handle then
		UpdateBeat:RemoveListener(arg0_106.handle)
	end

	if arg0_106._tf and LeanTween.isTweening(go(arg0_106._tf)) then
		LeanTween.cancel(go(arg0_106._tf))
	end

	if arg0_106.timer and arg0_106.timer.running then
		arg0_106.timer:Stop()
	end

	Time.timeScale = 1
	arg0_106.timer = nil
end

return var0_0
