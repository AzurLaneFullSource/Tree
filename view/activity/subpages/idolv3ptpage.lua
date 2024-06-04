local var0 = class("IdolV3PtPage", import(".TemplatePage.PtTemplatePage"))
local var1 = {
	"kewei_idol",
	"ougen_idol",
	"nengdai_idol",
	"jingang_idol",
	"lumang_idol",
	"boyixi_idol"
}

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.trainEntranceBtn = arg0:findTF("train_btn", arg0.bg)
	arg0.skills = arg0:findTF("skill", arg0.bg)
	arg0.skillBtns = {}

	for iter0 = 0, arg0.skills.childCount - 1 do
		table.insert(arg0.skillBtns, arg0.skills:GetChild(iter0))
	end

	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.idol1 = arg0:findTF("idol1", arg0.bg)
	arg0.buffInfoBox = arg0:findTF("BuffInfoBox")
	arg0.mask = arg0:findTF("mengban", arg0.buffInfoBox)
	arg0.buffWindow = arg0:findTF("panel", arg0.buffInfoBox)
	arg0.buffName = arg0:findTF("title/name", arg0.buffWindow)
	arg0.titleLv = arg0:findTF("title/lv", arg0.buffWindow)
	arg0.titleIcon = arg0:findTF("title/icon", arg0.buffWindow)
	arg0.buffTip = arg0:findTF("content/tip", arg0.buffWindow)
	arg0.desc = arg0:findTF("content/desc", arg0.buffWindow)
	arg0.buffAwardTF = arg0:findTF("award_bg/award", arg0.buffWindow)
	arg0.trainWindow = arg0:findTF("IdolTrainWindow")
	arg0.trainTitle = arg0:findTF("panel/title/Text", arg0.trainWindow)
	arg0.trainBtn = arg0:findTF("panel/train_btn", arg0.trainWindow)
	arg0.trainSkills = arg0:findTF("panel/skills", arg0.trainWindow)
	arg0.trainSkillBtns = {}

	for iter1 = 0, arg0.trainSkills.childCount - 1 do
		table.insert(arg0.trainSkillBtns, arg0.trainSkills:GetChild(iter1))
	end

	arg0.info = arg0:findTF("panel/info", arg0.trainWindow)
	arg0.curBuff = arg0:findTF("preview/current", arg0.info)
	arg0.nextBuff = arg0:findTF("preview/next", arg0.info)
	arg0.msgBox = arg0:findTF("MsgBox")
	arg0.msgIcon = arg0:findTF("panel/title/icon", arg0.msgBox)

	setText(arg0:findTF("panel/title/Text", arg0.msgBox), i18n("title_info"))

	arg0.msgContent = arg0:findTF("panel/content", arg0.msgBox)
	arg0.msgBoxMask = arg0:findTF("mengban", arg0.msgBox)
	arg0.cancelBtn = arg0:findTF("panel/cancel_btn", arg0.msgBox)
	arg0.confirmBtn = arg0:findTF("panel/confirm_btn", arg0.msgBox)
	arg0.tipPanel = arg0:findTF("Tip")
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	removeOnButton(arg0.getBtn)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getData()

		if var1.type == DROP_TYPE_RESOURCE and var1.id == PlayerConst.ResGold and var2:GoldMax(var1.count) then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1
			})
			arg0:playIdolAni()
		end)
	end, SFX_PANEL)
	removeOnButton(arg0.battleBtn)
	onButton(arg0, arg0.battleBtn, function()
		local var0
		local var1

		if arg0.activity:getConfig("config_client") ~= "" then
			var0 = arg0.activity:getConfig("config_client").linkActID

			if var0 then
				var1 = getProxy(ActivityProxy):getActivityById(var0)
			end
		end

		if not var0 then
			arg0:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1 and not var1:isEnd() then
			arg0:emit(ActivityMediator.BATTLE_OPERA)
		else
			arg0:showTip(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.trainEntranceBtn, function()
		arg0:showTrianPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("idol3rd_practice")
		})
	end, SFX_PANEL)
	arg0:hideBuffInfoBox()
	onButton(arg0, arg0.mask, function()
		arg0:hideBuffInfoBox()
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.skillBtns) do
		onButton(arg0, iter1, function()
			for iter0, iter1 in ipairs(arg0.ptData:GetCurBuffInfos()) do
				if iter0 == iter1.group then
					arg0:showBuffInfoBox(iter1)
				end
			end
		end, SFX_PANEL)
	end

	local var0 = var1[math.random(#var1)]

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.prefab1 = var0
		arg0.model1 = arg0
		tf(arg0).localScale = Vector3(1, 1, 1)

		arg0:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0, arg0.idol1)
	end)
	setActive(arg0.skills, arg0.ptData:isInBuffTime())
end

function var0.OnUpdateFlush(arg0)
	local var0 = false
	local var1 = arg0.ptData:CanTrain()

	if var1 and var1 <= arg0.ptData.level then
		var0 = true
	end

	local var2, var3, var4 = arg0.ptData:GetLevelProgress()
	local var5, var6, var7 = arg0.ptData:GetResProgress()

	setText(arg0.step, var2 .. "/" .. var3)
	setText(arg0.progress, var5 .. "/" .. var6)
	setSlider(arg0.slider, 0, 1, var7)

	local var8 = arg0.ptData:CanGetAward()
	local var9 = arg0.ptData:CanGetNextAward()
	local var10 = arg0.ptData:CanGetMorePt()
	local var11 = arg0.ptData:CanTrain()

	setActive(arg0.battleBtn, true)
	setActive(arg0.getBtn, var8 and not var0)
	setActive(arg0.trainEntranceBtn, var0)
	setActive(arg0.gotBtn, not var9 and not var11)

	local var12 = arg0.ptData:GetAward()

	updateDrop(arg0.awardTF, var12)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var12)
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.ptData:GetCurBuffInfos()) do
		setActive(arg0:findTF("lv1", arg0.skillBtns[iter1.group]), false)
		setActive(arg0:findTF("lv2", arg0.skillBtns[iter1.group]), false)
		setActive(arg0:findTF("lv3", arg0.skillBtns[iter1.group]), false)

		if iter1.next then
			setActive(arg0:findTF("lv" .. iter1.lv, arg0.skillBtns[iter1.group]), true)
		else
			setActive(arg0:findTF("lv3", arg0.skillBtns[iter1.group]), true)
		end

		local var13 = pg.benefit_buff_template[iter1.id].icon

		setImageSprite(arg0:findTF("icon", arg0.skillBtns[iter1.group]), LoadSprite(var13))
	end
end

function var0.showTrianPanel(arg0)
	setActive(arg0.trainWindow, true)
	setText(arg0.trainTitle, i18n("upgrade_idol_tip"))

	local var0 = arg0.ptData:GetCurBuffInfos()

	arg0.selectIndex = nil
	arg0.selectBuffId = nil
	arg0.selectBuffLv = nil
	arg0.selectNewBuffId = nil

	for iter0, iter1 in ipairs(arg0.trainSkillBtns) do
		onButton(arg0, iter1, function()
			for iter0, iter1 in ipairs(var0) do
				if iter0 == iter1.group and iter1.next then
					arg0.selectIndex = iter0
					arg0.selectBuffId = iter1.id
					arg0.selectNewBuffId = iter1.next
					arg0.selectBuffLv = iter1.lv
				end
			end

			arg0:flushTrainPanel()
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.trainBtn, function()
		arg0:showMsgBox()
	end, SFX_PANEL)

	local var1 = underscore.detect(var0, function(arg0)
		return arg0.next
	end)

	if var1 then
		triggerButton(arg0.trainSkillBtns[var1.group])
	end
end

function var0.hideTrianPanel(arg0)
	setActive(arg0.trainWindow, false)
end

function var0.flushTrainPanel(arg0)
	local var0 = arg0.ptData:GetCurBuffInfos()

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			setActive(arg0:findTF("lv1", arg0.trainSkillBtns[iter1.group]), false)
			setActive(arg0:findTF("lv2", arg0.trainSkillBtns[iter1.group]), false)
			setActive(arg0:findTF("lv3", arg0.trainSkillBtns[iter1.group]), false)

			if iter1.next then
				setActive(arg0:findTF("lv" .. iter1.lv, arg0.trainSkillBtns[iter1.group]), true)
			else
				setActive(arg0:findTF("lv3", arg0.trainSkillBtns[iter1.group]), true)
			end

			local var1 = pg.benefit_buff_template[iter1.id].icon

			setImageSprite(arg0:findTF("icon", arg0.trainSkillBtns[iter1.group]), LoadSprite(var1))
			setText(arg0:findTF("name", arg0.trainSkillBtns[iter1.group]), shortenString(pg.benefit_buff_template[iter1.id].name, 12))
		end
	end

	for iter2, iter3 in ipairs(arg0.trainSkillBtns) do
		if iter2 == arg0.selectIndex then
			setActive(arg0:findTF("selected", iter3), true)
			setActive(arg0:findTF("name", iter3), true)
		else
			setActive(arg0:findTF("selected", iter3), false)
			setActive(arg0:findTF("name", iter3), false)
		end
	end

	if arg0.selectIndex then
		setActive(arg0.info, true)
		setActive(arg0.trainBtn, true)
		setText(arg0.curBuff, "Lv." .. arg0.selectBuffLv .. pg.benefit_buff_template[arg0.selectBuffId].desc)
		setText(arg0.nextBuff, "Lv." .. arg0.selectBuffLv + 1 .. pg.benefit_buff_template[arg0.selectNewBuffId].desc)
	else
		setActive(arg0.info, false)
		setActive(arg0.trainBtn, false)
	end
end

function var0.showBuffInfoBox(arg0, arg1)
	local var0 = pg.benefit_buff_template[arg1.id].name

	setText(arg0.buffName, var0)
	setText(arg0.desc, pg.benefit_buff_template[arg1.id].desc)
	setText(arg0.buffTip, i18n("upgrade_introduce_tip", var0))

	local var1 = pg.benefit_buff_template[arg1.id].icon

	setImageSprite(arg0.titleIcon, LoadSprite(var1))

	local var2 = arg1.award

	updateDrop(arg0.buffAwardTF, var2)
	onButton(arg0, arg0.buffAwardTF, function()
		arg0:emit(BaseUI.ON_DROP, var2)
	end, SFX_PANEL)

	if arg1.next then
		setText(arg0.titleLv, "Lv." .. arg1.lv)
		setActive(arg0:findTF("icon_bg/got_mask", arg0.buffAwardTF), false)
	else
		setText(arg0.titleLv, "MAX")
		setActive(arg0:findTF("icon_bg/got_mask", arg0.buffAwardTF), true)
		removeOnButton(arg0.buffAwardTF)
	end

	setActive(arg0.buffInfoBox, true)
end

function var0.hideBuffInfoBox(arg0)
	setActive(arg0.buffInfoBox, false)
end

function var0.OnDestroy(arg0)
	if arg0.prefab1 and arg0.model1 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab1, arg0.model1)

		arg0.prefab1 = nil
		arg0.model1 = nil
	end
end

function var0.playIdolAni(arg0)
	if arg0.model1 then
		arg0.model1:GetComponent("SpineAnimUI"):SetAction("idol", 0)
	end
end

function var0.showMsgBox(arg0)
	if arg0.selectBuffId then
		setActive(arg0.msgBox, true)

		local var0 = pg.benefit_buff_template[arg0.selectBuffId].icon

		setImageSprite(arg0.msgIcon, LoadSprite(var0))

		local var1 = pg.benefit_buff_template[arg0.selectBuffId].name

		setText(arg0.msgContent, i18n("practise_idol_tip", var1))
		onButton(arg0, arg0.msgBoxMask, function()
			arg0:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0, arg0.cancelBtn, function()
			arg0:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0, arg0.confirmBtn, function()
			arg0:hideMsgBox()
			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 3,
				activity_id = arg0.ptData:GetId(),
				arg1 = arg0.ptData:CanTrain(),
				arg2 = arg0.selectNewBuffId,
				oldBuffId = arg0.selectBuffId,
				callback = function()
					arg0:hideTrianPanel()
					arg0:showTip(i18n("upgrade_complete_tip"))
				end
			})
		end, SFX_PANEL)
	end
end

function var0.hideMsgBox(arg0)
	setActive(arg0.msgBox, false)
end

function var0.showTip(arg0, arg1)
	local var0 = cloneTplTo(arg0.tipPanel, arg0._tf)

	setActive(var0, true)
	setText(arg0:findTF("Text", var0), arg1)

	var0.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local var1 = GetOrAddComponent(var0, "CanvasGroup")

	Timer.New(function()
		if IsNil(var0) then
			return
		end

		LeanTween.scale(var0, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			LeanTween.scale(var0, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				Destroy(var0)
			end))
		end))
	end, 3):Start()
end

return var0
