local var0_0 = class("IdolV3PtPage", import(".TemplatePage.PtTemplatePage"))
local var1_0 = {
	"kewei_idol",
	"ougen_idol",
	"nengdai_idol",
	"jingang_idol",
	"lumang_idol",
	"boyixi_idol"
}

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.trainEntranceBtn = arg0_1:findTF("train_btn", arg0_1.bg)
	arg0_1.skills = arg0_1:findTF("skill", arg0_1.bg)
	arg0_1.skillBtns = {}

	for iter0_1 = 0, arg0_1.skills.childCount - 1 do
		table.insert(arg0_1.skillBtns, arg0_1.skills:GetChild(iter0_1))
	end

	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)
	arg0_1.idol1 = arg0_1:findTF("idol1", arg0_1.bg)
	arg0_1.buffInfoBox = arg0_1:findTF("BuffInfoBox")
	arg0_1.mask = arg0_1:findTF("mengban", arg0_1.buffInfoBox)
	arg0_1.buffWindow = arg0_1:findTF("panel", arg0_1.buffInfoBox)
	arg0_1.buffName = arg0_1:findTF("title/name", arg0_1.buffWindow)
	arg0_1.titleLv = arg0_1:findTF("title/lv", arg0_1.buffWindow)
	arg0_1.titleIcon = arg0_1:findTF("title/icon", arg0_1.buffWindow)
	arg0_1.buffTip = arg0_1:findTF("content/tip", arg0_1.buffWindow)
	arg0_1.desc = arg0_1:findTF("content/desc", arg0_1.buffWindow)
	arg0_1.buffAwardTF = arg0_1:findTF("award_bg/award", arg0_1.buffWindow)
	arg0_1.trainWindow = arg0_1:findTF("IdolTrainWindow")
	arg0_1.trainTitle = arg0_1:findTF("panel/title/Text", arg0_1.trainWindow)
	arg0_1.trainBtn = arg0_1:findTF("panel/train_btn", arg0_1.trainWindow)
	arg0_1.trainSkills = arg0_1:findTF("panel/skills", arg0_1.trainWindow)
	arg0_1.trainSkillBtns = {}

	for iter1_1 = 0, arg0_1.trainSkills.childCount - 1 do
		table.insert(arg0_1.trainSkillBtns, arg0_1.trainSkills:GetChild(iter1_1))
	end

	arg0_1.info = arg0_1:findTF("panel/info", arg0_1.trainWindow)
	arg0_1.curBuff = arg0_1:findTF("preview/current", arg0_1.info)
	arg0_1.nextBuff = arg0_1:findTF("preview/next", arg0_1.info)
	arg0_1.msgBox = arg0_1:findTF("MsgBox")
	arg0_1.msgIcon = arg0_1:findTF("panel/title/icon", arg0_1.msgBox)

	setText(arg0_1:findTF("panel/title/Text", arg0_1.msgBox), i18n("title_info"))

	arg0_1.msgContent = arg0_1:findTF("panel/content", arg0_1.msgBox)
	arg0_1.msgBoxMask = arg0_1:findTF("mengban", arg0_1.msgBox)
	arg0_1.cancelBtn = arg0_1:findTF("panel/cancel_btn", arg0_1.msgBox)
	arg0_1.confirmBtn = arg0_1:findTF("panel/confirm_btn", arg0_1.msgBox)
	arg0_1.tipPanel = arg0_1:findTF("Tip")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	removeOnButton(arg0_2.getBtn)
	onButton(arg0_2, arg0_2.getBtn, function()
		local var0_3 = {}
		local var1_3 = arg0_2.ptData:GetAward()
		local var2_3 = getProxy(PlayerProxy):getData()

		if var1_3.type == DROP_TYPE_RESOURCE and var1_3.id == PlayerConst.ResGold and var2_3:GoldMax(var1_3.count) then
			table.insert(var0_3, function(arg0_4)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0_4
				})
			end)
		end

		seriesAsync(var0_3, function()
			local var0_5, var1_5 = arg0_2.ptData:GetResProgress()

			arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_2.ptData:GetId(),
				arg1 = var1_5
			})
			arg0_2:playIdolAni()
		end)
	end, SFX_PANEL)
	removeOnButton(arg0_2.battleBtn)
	onButton(arg0_2, arg0_2.battleBtn, function()
		local var0_6
		local var1_6

		if arg0_2.activity:getConfig("config_client") ~= "" then
			var0_6 = arg0_2.activity:getConfig("config_client").linkActID

			if var0_6 then
				var1_6 = getProxy(ActivityProxy):getActivityById(var0_6)
			end
		end

		if not var0_6 then
			arg0_2:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1_6 and not var1_6:isEnd() then
			arg0_2:emit(ActivityMediator.BATTLE_OPERA)
		else
			arg0_2:showTip(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.trainEntranceBtn, function()
		arg0_2:showTrianPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("idol3rd_practice")
		})
	end, SFX_PANEL)
	arg0_2:hideBuffInfoBox()
	onButton(arg0_2, arg0_2.mask, function()
		arg0_2:hideBuffInfoBox()
	end, SFX_PANEL)

	for iter0_2, iter1_2 in ipairs(arg0_2.skillBtns) do
		onButton(arg0_2, iter1_2, function()
			for iter0_10, iter1_10 in ipairs(arg0_2.ptData:GetCurBuffInfos()) do
				if iter0_2 == iter1_10.group then
					arg0_2:showBuffInfoBox(iter1_10)
				end
			end
		end, SFX_PANEL)
	end

	local var0_2 = var1_0[math.random(#var1_0)]

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var0_2, true, function(arg0_11)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_2.prefab1 = var0_2
		arg0_2.model1 = arg0_11
		tf(arg0_11).localScale = Vector3(1, 1, 1)

		arg0_11:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0_11, arg0_2.idol1)
	end)
	setActive(arg0_2.skills, arg0_2.ptData:isInBuffTime())
end

function var0_0.OnUpdateFlush(arg0_12)
	local var0_12 = false
	local var1_12 = arg0_12.ptData:CanTrain()

	if var1_12 and var1_12 <= arg0_12.ptData.level then
		var0_12 = true
	end

	local var2_12, var3_12, var4_12 = arg0_12.ptData:GetLevelProgress()
	local var5_12, var6_12, var7_12 = arg0_12.ptData:GetResProgress()

	setText(arg0_12.step, var2_12 .. "/" .. var3_12)
	setText(arg0_12.progress, var5_12 .. "/" .. var6_12)
	setSlider(arg0_12.slider, 0, 1, var7_12)

	local var8_12 = arg0_12.ptData:CanGetAward()
	local var9_12 = arg0_12.ptData:CanGetNextAward()
	local var10_12 = arg0_12.ptData:CanGetMorePt()
	local var11_12 = arg0_12.ptData:CanTrain()

	setActive(arg0_12.battleBtn, true)
	setActive(arg0_12.getBtn, var8_12 and not var0_12)
	setActive(arg0_12.trainEntranceBtn, var0_12)
	setActive(arg0_12.gotBtn, not var9_12 and not var11_12)

	local var12_12 = arg0_12.ptData:GetAward()

	updateDrop(arg0_12.awardTF, var12_12)
	onButton(arg0_12, arg0_12.awardTF, function()
		arg0_12:emit(BaseUI.ON_DROP, var12_12)
	end, SFX_PANEL)

	for iter0_12, iter1_12 in ipairs(arg0_12.ptData:GetCurBuffInfos()) do
		setActive(arg0_12:findTF("lv1", arg0_12.skillBtns[iter1_12.group]), false)
		setActive(arg0_12:findTF("lv2", arg0_12.skillBtns[iter1_12.group]), false)
		setActive(arg0_12:findTF("lv3", arg0_12.skillBtns[iter1_12.group]), false)

		if iter1_12.next then
			setActive(arg0_12:findTF("lv" .. iter1_12.lv, arg0_12.skillBtns[iter1_12.group]), true)
		else
			setActive(arg0_12:findTF("lv3", arg0_12.skillBtns[iter1_12.group]), true)
		end

		local var13_12 = pg.benefit_buff_template[iter1_12.id].icon

		setImageSprite(arg0_12:findTF("icon", arg0_12.skillBtns[iter1_12.group]), LoadSprite(var13_12))
	end
end

function var0_0.showTrianPanel(arg0_14)
	setActive(arg0_14.trainWindow, true)
	setText(arg0_14.trainTitle, i18n("upgrade_idol_tip"))

	local var0_14 = arg0_14.ptData:GetCurBuffInfos()

	arg0_14.selectIndex = nil
	arg0_14.selectBuffId = nil
	arg0_14.selectBuffLv = nil
	arg0_14.selectNewBuffId = nil

	for iter0_14, iter1_14 in ipairs(arg0_14.trainSkillBtns) do
		onButton(arg0_14, iter1_14, function()
			for iter0_15, iter1_15 in ipairs(var0_14) do
				if iter0_14 == iter1_15.group and iter1_15.next then
					arg0_14.selectIndex = iter0_14
					arg0_14.selectBuffId = iter1_15.id
					arg0_14.selectNewBuffId = iter1_15.next
					arg0_14.selectBuffLv = iter1_15.lv
				end
			end

			arg0_14:flushTrainPanel()
		end, SFX_PANEL)
	end

	onButton(arg0_14, arg0_14.trainBtn, function()
		arg0_14:showMsgBox()
	end, SFX_PANEL)

	local var1_14 = underscore.detect(var0_14, function(arg0_17)
		return arg0_17.next
	end)

	if var1_14 then
		triggerButton(arg0_14.trainSkillBtns[var1_14.group])
	end
end

function var0_0.hideTrianPanel(arg0_18)
	setActive(arg0_18.trainWindow, false)
end

function var0_0.flushTrainPanel(arg0_19)
	local var0_19 = arg0_19.ptData:GetCurBuffInfos()

	if var0_19 then
		for iter0_19, iter1_19 in ipairs(var0_19) do
			setActive(arg0_19:findTF("lv1", arg0_19.trainSkillBtns[iter1_19.group]), false)
			setActive(arg0_19:findTF("lv2", arg0_19.trainSkillBtns[iter1_19.group]), false)
			setActive(arg0_19:findTF("lv3", arg0_19.trainSkillBtns[iter1_19.group]), false)

			if iter1_19.next then
				setActive(arg0_19:findTF("lv" .. iter1_19.lv, arg0_19.trainSkillBtns[iter1_19.group]), true)
			else
				setActive(arg0_19:findTF("lv3", arg0_19.trainSkillBtns[iter1_19.group]), true)
			end

			local var1_19 = pg.benefit_buff_template[iter1_19.id].icon

			setImageSprite(arg0_19:findTF("icon", arg0_19.trainSkillBtns[iter1_19.group]), LoadSprite(var1_19))
			setText(arg0_19:findTF("name", arg0_19.trainSkillBtns[iter1_19.group]), shortenString(pg.benefit_buff_template[iter1_19.id].name, 12))
		end
	end

	for iter2_19, iter3_19 in ipairs(arg0_19.trainSkillBtns) do
		if iter2_19 == arg0_19.selectIndex then
			setActive(arg0_19:findTF("selected", iter3_19), true)
			setActive(arg0_19:findTF("name", iter3_19), true)
		else
			setActive(arg0_19:findTF("selected", iter3_19), false)
			setActive(arg0_19:findTF("name", iter3_19), false)
		end
	end

	if arg0_19.selectIndex then
		setActive(arg0_19.info, true)
		setActive(arg0_19.trainBtn, true)
		setText(arg0_19.curBuff, "Lv." .. arg0_19.selectBuffLv .. pg.benefit_buff_template[arg0_19.selectBuffId].desc)
		setText(arg0_19.nextBuff, "Lv." .. arg0_19.selectBuffLv + 1 .. pg.benefit_buff_template[arg0_19.selectNewBuffId].desc)
	else
		setActive(arg0_19.info, false)
		setActive(arg0_19.trainBtn, false)
	end
end

function var0_0.showBuffInfoBox(arg0_20, arg1_20)
	local var0_20 = pg.benefit_buff_template[arg1_20.id].name

	setText(arg0_20.buffName, var0_20)
	setText(arg0_20.desc, pg.benefit_buff_template[arg1_20.id].desc)
	setText(arg0_20.buffTip, i18n("upgrade_introduce_tip", var0_20))

	local var1_20 = pg.benefit_buff_template[arg1_20.id].icon

	setImageSprite(arg0_20.titleIcon, LoadSprite(var1_20))

	local var2_20 = arg1_20.award

	updateDrop(arg0_20.buffAwardTF, var2_20)
	onButton(arg0_20, arg0_20.buffAwardTF, function()
		arg0_20:emit(BaseUI.ON_DROP, var2_20)
	end, SFX_PANEL)

	if arg1_20.next then
		setText(arg0_20.titleLv, "Lv." .. arg1_20.lv)
		setActive(arg0_20:findTF("icon_bg/got_mask", arg0_20.buffAwardTF), false)
	else
		setText(arg0_20.titleLv, "MAX")
		setActive(arg0_20:findTF("icon_bg/got_mask", arg0_20.buffAwardTF), true)
		removeOnButton(arg0_20.buffAwardTF)
	end

	setActive(arg0_20.buffInfoBox, true)
end

function var0_0.hideBuffInfoBox(arg0_22)
	setActive(arg0_22.buffInfoBox, false)
end

function var0_0.OnDestroy(arg0_23)
	if arg0_23.prefab1 and arg0_23.model1 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_23.prefab1, arg0_23.model1)

		arg0_23.prefab1 = nil
		arg0_23.model1 = nil
	end
end

function var0_0.playIdolAni(arg0_24)
	if arg0_24.model1 then
		arg0_24.model1:GetComponent("SpineAnimUI"):SetAction("idol", 0)
	end
end

function var0_0.showMsgBox(arg0_25)
	if arg0_25.selectBuffId then
		setActive(arg0_25.msgBox, true)

		local var0_25 = pg.benefit_buff_template[arg0_25.selectBuffId].icon

		setImageSprite(arg0_25.msgIcon, LoadSprite(var0_25))

		local var1_25 = pg.benefit_buff_template[arg0_25.selectBuffId].name

		setText(arg0_25.msgContent, i18n("practise_idol_tip", var1_25))
		onButton(arg0_25, arg0_25.msgBoxMask, function()
			arg0_25:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_25, arg0_25.cancelBtn, function()
			arg0_25:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_25, arg0_25.confirmBtn, function()
			arg0_25:hideMsgBox()
			arg0_25:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 3,
				activity_id = arg0_25.ptData:GetId(),
				arg1 = arg0_25.ptData:CanTrain(),
				arg2 = arg0_25.selectNewBuffId,
				oldBuffId = arg0_25.selectBuffId,
				callback = function()
					arg0_25:hideTrianPanel()
					arg0_25:showTip(i18n("upgrade_complete_tip"))
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.hideMsgBox(arg0_30)
	setActive(arg0_30.msgBox, false)
end

function var0_0.showTip(arg0_31, arg1_31)
	local var0_31 = cloneTplTo(arg0_31.tipPanel, arg0_31._tf)

	setActive(var0_31, true)
	setText(arg0_31:findTF("Text", var0_31), arg1_31)

	var0_31.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0_31, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0_31, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local var1_31 = GetOrAddComponent(var0_31, "CanvasGroup")

	Timer.New(function()
		if IsNil(var0_31) then
			return
		end

		LeanTween.scale(var0_31, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			LeanTween.scale(var0_31, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				Destroy(var0_31)
			end))
		end))
	end, 3):Start()
end

return var0_0
