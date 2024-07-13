local var0_0 = class("IdolTrainPtPage", import(".TemplatePage.PtTemplatePage"))
local var1_0 = {
	"dafeng_idol",
	"tashigan_idol",
	"daiduo_idol",
	"daqinghuayu_idol",
	"baerdimo_idol",
	"luoen_idol",
	"guanghui_idol",
	"edu_idol"
}

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.skills = arg0_1:findTF("skill", arg0_1.bg)
	arg0_1.skillBtns = {}

	eachChild(arg0_1.skills, function(arg0_2)
		table.insert(arg0_1.skillBtns, arg0_2)
	end)

	arg0_1.getGreyBtn = arg0_1:findTF("get_grey_btn", arg0_1.bg)
	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)
	arg0_1.idol1 = arg0_1:findTF("idol1", arg0_1.bg)
	arg0_1.idol2 = arg0_1:findTF("idol2", arg0_1.bg)
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

	eachChild(arg0_1.trainSkills, function(arg0_3)
		table.insert(arg0_1.trainSkillBtns, arg0_3)
	end)

	arg0_1.info = arg0_1:findTF("panel/info", arg0_1.trainWindow)
	arg0_1.curBuff = arg0_1:findTF("preview/current", arg0_1.info)
	arg0_1.nextBuff = arg0_1:findTF("preview/next", arg0_1.info)
	arg0_1.msgBox = arg0_1:findTF("MsgBox")
	arg0_1.msgIcon = arg0_1:findTF("panel/title/icon", arg0_1.msgBox)
	arg0_1.msgContent = arg0_1:findTF("panel/content", arg0_1.msgBox)
	arg0_1.msgBoxMask = arg0_1:findTF("mengban", arg0_1.msgBox)
	arg0_1.cancelBtn = arg0_1:findTF("panel/cancel_btn", arg0_1.msgBox)
	arg0_1.confirmBtn = arg0_1:findTF("panel/confirm_btn", arg0_1.msgBox)
	arg0_1.tipPanel = arg0_1:findTF("Tip")
end

function var0_0.OnFirstFlush(arg0_4)
	var0_0.super.OnFirstFlush(arg0_4)
	removeOnButton(arg0_4.getBtn)
	onButton(arg0_4, arg0_4.getBtn, function()
		local var0_5 = {}
		local var1_5 = arg0_4.ptData:GetAward()
		local var2_5 = getProxy(PlayerProxy):getData()

		if var1_5.type == DROP_TYPE_RESOURCE and var1_5.id == PlayerConst.ResGold and var2_5:GoldMax(var1_5.count) then
			table.insert(var0_5, function(arg0_6)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0_6
				})
			end)
		end

		seriesAsync(var0_5, function()
			local var0_7, var1_7 = arg0_4.ptData:GetResProgress()

			arg0_4:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_4.ptData:GetId(),
				arg1 = var1_7
			})

			if arg0_4.ptData:CanTrain() then
				arg0_4:showTrianPanel()
			end

			arg0_4:playIdolAni()
		end)
	end, SFX_PANEL)
	removeOnButton(arg0_4.battleBtn)
	onButton(arg0_4, arg0_4.battleBtn, function()
		local var0_8
		local var1_8

		if arg0_4.activity:getConfig("config_client") ~= "" then
			var0_8 = arg0_4.activity:getConfig("config_client").linkActID

			if var0_8 then
				var1_8 = getProxy(ActivityProxy):getActivityById(var0_8)
			end
		end

		if not var0_8 then
			arg0_4:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1_8 and not var1_8:isEnd() then
			arg0_4:emit(ActivityMediator.BATTLE_OPERA)
		else
			arg0_4:showTip(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	arg0_4:hideBuffInfoBox()
	onButton(arg0_4, arg0_4.mask, function()
		arg0_4:hideBuffInfoBox()
	end, SFX_PANEL)

	for iter0_4, iter1_4 in ipairs(arg0_4.skillBtns) do
		onButton(arg0_4, iter1_4, function()
			for iter0_10, iter1_10 in ipairs(arg0_4.ptData:GetCurBuffInfos()) do
				if iter0_4 == iter1_10.group then
					arg0_4:showBuffInfoBox(iter1_10)
				end
			end
		end, SFX_PANEL)
	end

	local var0_4, var1_4 = arg0_4:getRandomName()

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var0_4, true, function(arg0_11)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_4.prefab1 = var0_4
		arg0_4.model1 = arg0_11
		tf(arg0_11).localScale = Vector3(1, 1, 1)

		arg0_11:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0_11, arg0_4.idol1)
	end)
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var1_4, true, function(arg0_12)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_4.prefab2 = var1_4
		arg0_4.model2 = arg0_12
		tf(arg0_12).localScale = Vector3(1, 1, 1)

		arg0_12:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0_12, arg0_4.idol2)
	end)
end

function var0_0.OnUpdateFlush(arg0_13)
	local var0_13 = arg0_13.ptData:CanTrain()

	if var0_13 and var0_13 <= arg0_13.ptData.level then
		arg0_13:showTrianPanel()
	end

	local var1_13, var2_13, var3_13 = arg0_13.ptData:GetLevelProgress()
	local var4_13, var5_13, var6_13 = arg0_13.ptData:GetResProgress()

	setText(arg0_13.step, setColorStr("PHASE  " .. var1_13 .. "/", COLOR_WHITE) .. var2_13)
	setText(arg0_13.progress, (var6_13 >= 1 and setColorStr(var4_13 .. "/", COLOR_WHITE) or var4_13 .. "/") .. var5_13)
	setSlider(arg0_13.slider, 0, 1, var6_13)

	local var7_13 = arg0_13.ptData:CanGetAward()
	local var8_13 = arg0_13.ptData:CanGetNextAward()
	local var9_13 = arg0_13.ptData:CanGetMorePt()
	local var10_13 = arg0_13.ptData:CanTrain()

	setActive(arg0_13.battleBtn, var9_13 and not var7_13 and var8_13)
	setActive(arg0_13.getBtn, var7_13)
	setActive(arg0_13.getGreyBtn, not var7_13)
	setActive(arg0_13.gotBtn, not var8_13 and not var10_13)

	local var11_13 = arg0_13.ptData:GetAward()

	updateDrop(arg0_13.awardTF, var11_13)
	onButton(arg0_13, arg0_13.awardTF, function()
		arg0_13:emit(BaseUI.ON_DROP, var11_13)
	end, SFX_PANEL)

	for iter0_13, iter1_13 in ipairs(arg0_13.ptData:GetCurBuffInfos()) do
		setActive(arg0_13:findTF("lv1", arg0_13.skillBtns[iter1_13.group]), false)
		setActive(arg0_13:findTF("lv2", arg0_13.skillBtns[iter1_13.group]), false)
		setActive(arg0_13:findTF("lv3", arg0_13.skillBtns[iter1_13.group]), false)

		if iter1_13.next then
			setActive(arg0_13:findTF("lv" .. iter1_13.lv, arg0_13.skillBtns[iter1_13.group]), true)
		else
			setActive(arg0_13:findTF("lv3", arg0_13.skillBtns[iter1_13.group]), true)
		end

		local var12_13 = pg.benefit_buff_template[iter1_13.id].icon

		setImageSprite(arg0_13:findTF("icon", arg0_13.skillBtns[iter1_13.group]), LoadSprite(var12_13))
	end

	onButton(arg0_13, arg0_13.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("practise_idol_help")
		})
	end, SFX_PANEL)
end

function var0_0.showTrianPanel(arg0_16)
	setActive(arg0_16.trainWindow, true)
	setText(arg0_16.trainTitle, i18n("upgrade_idol_tip"))

	local var0_16 = arg0_16.ptData:GetCurBuffInfos()

	arg0_16.selectIndex = nil
	arg0_16.selectBuffId = nil
	arg0_16.selectBuffLv = nil
	arg0_16.selectNewBuffId = nil

	for iter0_16, iter1_16 in ipairs(arg0_16.trainSkillBtns) do
		onButton(arg0_16, iter1_16, function()
			for iter0_17, iter1_17 in ipairs(var0_16) do
				if iter0_16 == iter1_17.group then
					if iter1_17.next then
						arg0_16.selectIndex = iter0_16
						arg0_16.selectBuffId = iter1_17.id
						arg0_16.selectNewBuffId = iter1_17.next
						arg0_16.selectBuffLv = iter1_17.lv
					else
						arg0_16.selectIndex = nil
						arg0_16.selectBuffId = nil
						arg0_16.selectNewBuffId = nil
						arg0_16.selectBuffLv = nil
					end
				end
			end

			arg0_16:flushTrainPanel()
		end, SFX_PANEL)
	end

	onButton(arg0_16, arg0_16.trainBtn, function()
		arg0_16:showMsgBox()
	end, SFX_PANEL)
	arg0_16:flushTrainPanel()
end

function var0_0.hideTrianPanel(arg0_19)
	setActive(arg0_19.trainWindow, false)
end

function var0_0.flushTrainPanel(arg0_20)
	local var0_20 = arg0_20.ptData:GetCurBuffInfos()

	if var0_20 then
		for iter0_20, iter1_20 in ipairs(var0_20) do
			setActive(arg0_20:findTF("lv1", arg0_20.trainSkillBtns[iter1_20.group]), false)
			setActive(arg0_20:findTF("lv2", arg0_20.trainSkillBtns[iter1_20.group]), false)
			setActive(arg0_20:findTF("lv3", arg0_20.trainSkillBtns[iter1_20.group]), false)

			if iter1_20.next then
				setActive(arg0_20:findTF("lv" .. iter1_20.lv, arg0_20.trainSkillBtns[iter1_20.group]), true)
			else
				setActive(arg0_20:findTF("lv3", arg0_20.trainSkillBtns[iter1_20.group]), true)
			end

			local var1_20 = pg.benefit_buff_template[iter1_20.id].icon

			setImageSprite(arg0_20:findTF("icon", arg0_20.trainSkillBtns[iter1_20.group]), LoadSprite(var1_20))
			setText(arg0_20:findTF("name", arg0_20.trainSkillBtns[iter1_20.group]), shortenString(pg.benefit_buff_template[iter1_20.id].name, 7))
		end
	end

	for iter2_20, iter3_20 in ipairs(arg0_20.trainSkillBtns) do
		if iter2_20 == arg0_20.selectIndex then
			setActive(arg0_20:findTF("selected", iter3_20), true)
			setActive(arg0_20:findTF("name", iter3_20), true)
		else
			setActive(arg0_20:findTF("selected", iter3_20), false)
			setActive(arg0_20:findTF("name", iter3_20), false)
		end
	end

	if arg0_20.selectIndex then
		setActive(arg0_20.info, true)
		setActive(arg0_20.trainBtn, true)
		setText(arg0_20.curBuff, "Lv." .. arg0_20.selectBuffLv .. pg.benefit_buff_template[arg0_20.selectBuffId].desc)
		setText(arg0_20.nextBuff, "Lv." .. arg0_20.selectBuffLv + 1 .. pg.benefit_buff_template[arg0_20.selectNewBuffId].desc)
	else
		setActive(arg0_20.info, false)
		setActive(arg0_20.trainBtn, false)
	end
end

function var0_0.showBuffInfoBox(arg0_21, arg1_21)
	local var0_21 = pg.benefit_buff_template[arg1_21.id].name

	setText(arg0_21.buffName, var0_21)
	setText(arg0_21.desc, pg.benefit_buff_template[arg1_21.id].desc)
	setText(arg0_21.buffTip, i18n("upgrade_introduce_tip", var0_21))

	local var1_21 = pg.benefit_buff_template[arg1_21.id].icon

	setImageSprite(arg0_21.titleIcon, LoadSprite(var1_21))

	local var2_21 = arg1_21.award

	updateDrop(arg0_21.buffAwardTF, var2_21)
	onButton(arg0_21, arg0_21.buffAwardTF, function()
		arg0_21:emit(BaseUI.ON_DROP, var2_21)
	end, SFX_PANEL)

	if arg1_21.next then
		setText(arg0_21.titleLv, "Lv." .. arg1_21.lv)
		setActive(arg0_21:findTF("icon_bg/got_mask", arg0_21.buffAwardTF), false)
	else
		setText(arg0_21.titleLv, "MAX")
		setActive(arg0_21:findTF("icon_bg/got_mask", arg0_21.buffAwardTF), true)
		removeOnButton(arg0_21.buffAwardTF)
	end

	setActive(arg0_21.buffInfoBox, true)
end

function var0_0.hideBuffInfoBox(arg0_23)
	setActive(arg0_23.buffInfoBox, false)
end

function var0_0.OnDestroy(arg0_24)
	if arg0_24.prefab1 and arg0_24.model1 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_24.prefab1, arg0_24.model1)

		arg0_24.prefab1 = nil
		arg0_24.model1 = nil
	end

	if arg0_24.prefab2 and arg0_24.model2 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_24.prefab2, arg0_24.model2)

		arg0_24.prefab2 = nil
		arg0_24.model2 = nil
	end
end

function var0_0.getRandomName(arg0_25)
	local var0_25 = math.random(#var1_0)
	local var1_25

	while var1_25 == var0_25 or not var1_25 do
		var1_25 = math.random(#var1_0)
	end

	return var1_0[var0_25], var1_0[var1_25]
end

function var0_0.playIdolAni(arg0_26)
	if arg0_26.model1 then
		arg0_26.model1:GetComponent("SpineAnimUI"):SetAction("idol", 0)
	end

	if arg0_26.model2 then
		arg0_26.model2:GetComponent("SpineAnimUI"):SetAction("idol", 0)
	end
end

function var0_0.showMsgBox(arg0_27)
	if arg0_27.selectBuffId then
		setActive(arg0_27.msgBox, true)

		local var0_27 = pg.benefit_buff_template[arg0_27.selectBuffId].icon

		setImageSprite(arg0_27.msgIcon, LoadSprite(var0_27))

		local var1_27 = pg.benefit_buff_template[arg0_27.selectBuffId].name

		setText(arg0_27.msgContent, i18n("practise_idol_tip", var1_27))
		onButton(arg0_27, arg0_27.msgBoxMask, function()
			arg0_27:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_27, arg0_27.cancelBtn, function()
			arg0_27:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_27, arg0_27.confirmBtn, function()
			arg0_27:hideMsgBox()
			arg0_27:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 3,
				activity_id = arg0_27.ptData:GetId(),
				arg1 = arg0_27.ptData:CanTrain(),
				arg2 = arg0_27.selectNewBuffId,
				oldBuffId = arg0_27.selectBuffId
			})
			arg0_27:hideTrianPanel()
			arg0_27:showTip(i18n("upgrade_complete_tip"))
		end, SFX_PANEL)
	end
end

function var0_0.hideMsgBox(arg0_31)
	setActive(arg0_31.msgBox, false)
end

function var0_0.showTip(arg0_32, arg1_32)
	local var0_32 = cloneTplTo(arg0_32.tipPanel, arg0_32._tf)

	setActive(var0_32, true)
	setText(arg0_32:findTF("Text", var0_32), arg1_32)

	var0_32.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0_32, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0_32, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local var1_32 = GetOrAddComponent(var0_32, "CanvasGroup")

	Timer.New(function()
		if IsNil(var0_32) then
			return
		end

		LeanTween.scale(var0_32, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			LeanTween.scale(var0_32, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				Destroy(var0_32)
			end))
		end))
	end, 3):Start()
end

return var0_0
