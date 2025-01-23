local var0_0 = class("NewEducateAssessPanel", import("view.base.BaseSubView"))

var0_0.CRIT_PERCENT = 200
var0_0.SPEED = 3

function var0_0.getUIName(arg0_1)
	return "NewEducateAssessPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.assessTF = arg0_2.rootTF:Find("assess")
	arg0_2.bgTF = arg0_2.assessTF:Find("bg")
	arg0_2.damageBlood = arg0_2.assessTF:Find("content/blood/red")
	arg0_2.bossTF = arg0_2.assessTF:Find("content/boss")
	arg0_2.roleTF = arg0_2.assessTF:Find("content/role")
	arg0_2.damageTF = arg0_2.assessTF:Find("content/damage")
	arg0_2.damageCritTF = arg0_2.assessTF:Find("content/damage_crit")

	local var0_2 = arg0_2.assessTF:Find("content/attrs")

	arg0_2.attrUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))
	arg0_2.resultTF = arg0_2.assessTF:Find("content/result")
	arg0_2.rankTF = arg0_2.resultTF:Find("rank")
	arg0_2.tipTF = arg0_2.rootTF:Find("tip")
	arg0_2.assessTextTF = arg0_2.tipTF:Find("content/assess/Text")
	arg0_2.targetTextTF = arg0_2.tipTF:Find("content/target/Text")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:AdjustSpeed()
	end, SFX_PANEL)
	arg0_3.attrUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			local var0_5 = arg0_3.attrIds[arg1_5 + 1]

			arg2_5.name = var0_5

			local var1_5 = pg.child2_attr[var0_5].icon

			LoadImageSpriteAtlasAsync("ui/neweducateassesspanel_atlas", var1_5, arg2_5)
			LoadImageSpriteAtlasAsync("ui/neweducateassesspanel_atlas", var1_5 .. "_l", arg2_5:Find("selected"))
		elseif arg0_5 == UIItemList.EventUpdate then
			local var2_5 = arg0_3.attrIds[arg1_5 + 1]

			setActive(arg2_5:Find("selected"), arg0_3.curAttrIdx == arg1_5 + 1)
			setText(arg2_5:Find("value"), arg0_3.contextData.char:GetAttr(var2_5))

			local var3_5 = arg0_3.curAttrIdx == arg1_5 + 1 and "47b9f4" or "6f6f82"

			setTextColor(arg2_5:Find("value"), Color.NewHex(var3_5))
		end
	end)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	arg0_6.callback = arg1_6

	pg.UIMgr.GetInstance():OverlayPanel(arg0_6._tf, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 1
	})
	arg0_6:InitData()
	arg0_6:InitStaticUI()
	arg0_6:PlayAnim()
end

function var0_0.InitData(arg0_7)
	arg0_7.speed = 1

	local var0_7 = arg0_7.contextData.char:GetRoundData()
	local var1_7 = pg.child2_target[var0_7:getConfig("target_id")]

	arg0_7.rank = var1_7.display[arg0_7.contextData.char:GetAssessRankIdx()]
	arg0_7.totolHP = var1_7.attr_sum
	arg0_7.damageHP = 0
	arg0_7.attrIds = arg0_7.contextData.char:GetAttrIds()
	arg0_7.curAttrIdx = 1
	arg0_7.tag = arg0_7.contextData.char:GetPersonalityTag()
	arg0_7.charConfig = arg0_7.contextData.char:getConfig("spine_char")
	arg0_7.standardValue = arg0_7.totolHP / #arg0_7.attrIds

	local var2_7 = arg0_7.contextData.char:getConfig("exam_action")[arg0_7.tag]

	arg0_7.actionConfig = {}

	underscore.each(var2_7, function(arg0_8)
		table.insert(arg0_7.actionConfig, {
			value = arg0_7.standardValue * arg0_8[1] / 100,
			name = arg0_8[2]
		})
	end)
	table.sort(arg0_7.actionConfig, CompareFuncs({
		function(arg0_9)
			return -arg0_9.value
		end
	}))

	local var3_7, var4_7, var5_7 = var0_7:GetProgressInfo()

	setText(arg0_7.assessTextTF, i18n("child2_assess_start_tip"))
	setText(arg0_7.targetTextTF, i18n("child2_assess_tip_target", var5_7))
end

function var0_0.GetAtkActionName(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.actionConfig) do
		if arg1_10 > iter1_10.value then
			return iter1_10.name
		end
	end

	return arg0_10.actionConfig[#arg0_10.actionConfig].name
end

function var0_0.InitStaticUI(arg0_11)
	LoadImageSpriteAtlasAsync("ui/neweducateassesspanel_atlas", "bg_" .. arg0_11.tag, arg0_11.bgTF)
	removeAllChildren(arg0_11.bossTF)
	removeAllChildren(arg0_11.roleTF)
	setActive(arg0_11.resultTF, false)
	setActive(arg0_11.damageTF, false)
	setActive(arg0_11.damageCritTF, false)
	setActive(arg0_11.resultTF:Find("title_gold"), arg0_11.rank == "S")
	setActive(arg0_11.resultTF:Find("title_red"), arg0_11.rank ~= "S")
	LoadImageSpriteAtlasAsync("ui/neweducateassesspanel_atlas", arg0_11.rank, arg0_11.rankTF)
	setFillAmount(arg0_11.damageBlood, 0)
	table.sort(arg0_11.attrIds)
	arg0_11.attrUIList:align(#arg0_11.attrIds)
end

function var0_0.ShowResult(arg0_12)
	setActive(arg0_12.resultTF, true)

	local var0_12 = arg0_12.contextData.char:GetAssessRankIdx()

	arg0_12:emit(NewEducateMainMediator.ON_SET_ASSESS_RANK, var0_12, function()
		existCall(arg0_12.callback)
	end)
end

function var0_0.PlayAnim(arg0_14)
	seriesAsync({
		function(arg0_15)
			arg0_14:ShowTip(arg0_15)
		end,
		function(arg0_16)
			arg0_14:LoadChar(arg0_16)
		end,
		function(arg0_17)
			arg0_14:CheckGuide(arg0_17)
		end,
		function(arg0_18)
			arg0_14:PlayOneATK(arg0_18)
		end
	}, function()
		arg0_14:ShowResult()
	end)
end

function var0_0.ShowTip(arg0_20, arg1_20)
	setActive(arg0_20.assessTF, false)
	setActive(arg0_20.tipTF, true)
	onDelayTick(function()
		setActive(arg0_20.tipTF, false)
		setActive(arg0_20.assessTF, true)
		arg1_20()
	end, 1)
end

function var0_0.CheckGuide(arg0_22, arg1_22)
	if pg.NewStoryMgr.GetInstance():IsPlayed("tb2_12") then
		arg1_22(arg1_22)
	else
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "tb2_12"
		})
		pg.NewGuideMgr.GetInstance():Play("tb2_12", {}, arg1_22, arg1_22)
	end
end

function var0_0.LoadChar(arg0_23, arg1_23)
	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync({
		function(arg0_24)
			PoolMgr.GetInstance():GetSpineChar(arg0_23.charConfig.boss, true, function(arg0_25)
				arg0_23.bossName = arg0_23.charConfig.boss
				arg0_23.bossModel = arg0_25
				tf(arg0_25).localScale = Vector3(1, 1, 1)

				arg0_25:GetComponent("SpineAnimUI"):SetAction("child2_boss_normal", 0)
				setParent(arg0_25, arg0_23.bossTF)
				arg0_24()
			end)
		end,
		function(arg0_26)
			PoolMgr.GetInstance():GetSpineChar(arg0_23.charConfig[arg0_23.tag], true, function(arg0_27)
				arg0_23.roleName = arg0_23.charConfig[arg0_23.tag]
				arg0_23.roleModel = arg0_27
				tf(arg0_27).localScale = Vector3(1, 1, 1)

				arg0_27:GetComponent("SpineAnimUI"):SetAction(arg0_23.roleName .. "_normal", 0)
				setParent(arg0_27, arg0_23.roleTF)
				arg0_26()
			end)
		end
	}, function()
		pg.UIMgr.GetInstance():LoadingOff()
		existCall(arg1_23)
	end)
end

function var0_0.PlayOneATK(arg0_29, arg1_29)
	local var0_29 = arg0_29.attrIds[arg0_29.curAttrIdx]
	local var1_29 = arg0_29.contextData.char:GetAttr(var0_29)

	arg0_29.damageHP = arg0_29.damageHP + var1_29

	local var2_29 = arg0_29:GetAtkActionName(var1_29)
	local var3_29 = var1_29 >= arg0_29.standardValue * var0_0.CRIT_PERCENT / 100 and arg0_29.damageCritTF or arg0_29.damageTF

	setText(var3_29, "-" .. var1_29)

	local var4_29 = arg0_29.bossModel:GetComponent(typeof(SpineAnimUI))

	var4_29:Resume()
	var4_29:SetAction("child2_boss_normal", 0)

	local var5_29 = arg0_29.roleModel:GetComponent(typeof(SpineAnimUI))

	var5_29:SetAction(arg0_29.roleName .. "_normal", 0)
	seriesAsync({
		function(arg0_30)
			arg0_29.attrUIList:align(#arg0_29.attrIds)
			blinkAni(arg0_29.attrUIList.container:Find(tostring(var0_29)), 0.2 / arg0_29.speed, 3)
			arg0_29:managedTween(LeanTween.delayedCall, function()
				arg0_30()
			end, 1 / arg0_29.speed, nil)
		end,
		function(arg0_32)
			var5_29:SetActionCallBack(function(arg0_33)
				if arg0_33 == "finish" then
					arg0_32()
					var5_29:SetActionCallBack(nil)
					var5_29:SetAction(arg0_29.roleName .. "_normal", 0)
				end
			end)
			var5_29:SetAction(var2_29, 0)
		end,
		function(arg0_34)
			setActive(var3_29, true)
			setFillAmount(arg0_29.damageBlood, math.min(arg0_29.damageHP / arg0_29.totolHP, 1))

			if arg0_29.damageHP < arg0_29.totolHP then
				var4_29:SetActionCallBack(function(arg0_35)
					if arg0_35 == "finish" then
						setActive(var3_29, false)
						arg0_34()
						var4_29:SetActionCallBack(nil)
						var4_29:SetAction("child2_boss_normal", 0)
					end
				end)
				var4_29:SetAction("child2_boss_shouji", 0)
			else
				var4_29:SetActionCallBack(function(arg0_36)
					if arg0_36 == "finish" then
						setActive(var3_29, false)
						arg0_34()
						var4_29:SetActionCallBack(nil)
						var4_29:Pause()
					end
				end)
				var4_29:SetAction("child2_boss_jidao", 0)
			end
		end
	}, function()
		if arg0_29.damageHP >= arg0_29.totolHP or arg0_29.curAttrIdx == #arg0_29.attrIds then
			arg1_29()
		else
			arg0_29.curAttrIdx = arg0_29.curAttrIdx + 1

			arg0_29:managedTween(LeanTween.delayedCall, function()
				arg0_29:PlayOneATK(arg1_29)
			end, 0.5 / arg0_29.speed, nil)
		end
	end)
end

function var0_0.AdjustSpeed(arg0_39)
	arg0_39.speed = var0_0.SPEED

	if arg0_39.bossModel then
		arg0_39:GetAnimationState(arg0_39.bossModel).TimeScale = arg0_39.speed
	end

	if arg0_39.roleModel then
		arg0_39:GetAnimationState(arg0_39.roleModel).TimeScale = arg0_39.speed
	end
end

function var0_0.GetAnimationState(arg0_40, arg1_40)
	return arg1_40:GetComponent("Spine.Unity.SkeletonGraphic").AnimationState
end

function var0_0.Hide(arg0_41)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_41._tf)

	if arg0_41.bossName and arg0_41.bossModel then
		arg0_41:GetAnimationState(arg0_41.bossModel).TimeScale = 1

		PoolMgr.GetInstance():ReturnSpineChar(arg0_41.bossName, arg0_41.bossModel)

		arg0_41.bossName = nil
		arg0_41.bossModel = nil
	end

	if arg0_41.roleName and arg0_41.roleModel then
		arg0_41:GetAnimationState(arg0_41.roleModel).TimeScale = 1

		PoolMgr.GetInstance():ReturnSpineChar(arg0_41.roleName, arg0_41.roleModel)

		arg0_41.roleName = nil
		arg0_41.roleModel = nil
	end

	var0_0.super.Hide(arg0_41)
end

function var0_0.OnDestroy(arg0_42)
	return
end

return var0_0
