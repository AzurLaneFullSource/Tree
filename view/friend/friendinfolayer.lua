local var0_0 = class("FriendInfoLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "FriendInfoUI"
end

function var0_0.setFriend(arg0_2, arg1_2)
	arg0_2.friend = arg1_2
end

function var0_0.setFriendProxy(arg0_3, arg1_3)
	arg0_3.friendProxy = arg1_3
end

local var1_0 = {
	"OPEN_RESUME",
	"OPEND_FRIEND",
	"OPEN_BACKYARD",
	"TOGGLE_BLACK",
	"OPEN_INFORM"
}

function var0_0.init(arg0_4)
	if arg0_4.contextData.form == NotificationLayer.FORM_BATTLE then
		setParent(arg0_4._tf, arg0_4.contextData.parent)
	elseif arg0_4.contextData.form == NotificationLayer.FORM_MAIN then
		pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
			groupName = arg0_4:getGroupNameFromData(),
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf, {
			groupName = arg0_4:getGroupNameFromData(),
			weight = LayerWeightConst.SECOND_LAYER
		})
	end

	arg0_4.frame = arg0_4:findTF("frame")
	arg0_4.iconTF = arg0_4:findTF("frame/left_bg/icon_bg/frame/icon"):GetComponent(typeof(Image))
	arg0_4.starsTF = arg0_4:findTF("frame/left_bg/icon_bg/stars")
	arg0_4.starTF = arg0_4:findTF("frame/left_bg/icon_bg/stars/star")
	arg0_4.playerNameTF = arg0_4:findTF("frame/left_bg/name_bg/Text"):GetComponent(typeof(Text))
	arg0_4.levelTF = arg0_4:findTF("frame/left_bg/icon_bg/lv/Text"):GetComponent(typeof(Text))
	arg0_4.resumeEmblem = arg0_4:findTF("frame/left_bg/emblem")
	arg0_4.resumeRank = arg0_4:findTF("frame/left_bg/emblem/Text"):GetComponent(typeof(Text))
	arg0_4.informPanel = arg0_4:findTF("inform_panel")
	arg0_4.toggleTpl = arg0_4:findTF("inform_panel/frame/window/main/Toggle")
	arg0_4.buttonTpl = arg0_4:findTF("inform_panel/frame/window/main/button")
	arg0_4.toggleContainer = arg0_4:findTF("inform_panel/frame/window/main/toggles")
	arg0_4.confirmBtn = arg0_4:findTF("frame/window/buttons/confirm_btn", arg0_4.informPanel)
	arg0_4.cancelBtn = arg0_4:findTF("frame/window/buttons/cancel_btn", arg0_4.informPanel)
	arg0_4.backBtn = arg0_4:findTF("inform_panel/frame/window/top/btnBack")
	arg0_4.nameTF = arg0_4:findTF("inform_panel/frame/window/name"):GetComponent(typeof(Text))

	if arg0_4.contextData.pos then
		if arg0_4.contextData.backyardView then
			local var0_4 = arg0_4:findTF("frame_for_backyard")

			var0_4.position = arg0_4.contextData.pos
			var0_4.localPosition = Vector3(var0_4.localPosition.x, var0_4.localPosition.y, 0)
		else
			arg0_4.height = arg0_4._tf.rect.height
			arg0_4.frame.position = arg0_4.contextData.pos

			local var1_4 = arg0_4.frame.localPosition
			local var2_4 = -1 * (arg0_4.height / 2 - arg0_4.frame.sizeDelta.y)
			local var3_4 = var2_4 >= var1_4.y and var2_4 or var1_4.y

			arg0_4.frame.localPosition = Vector3(var1_4.x, var3_4, 0)
		end
	end
end

function var0_0.didEnter(arg0_5)
	arg0_5:Init()
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
end

function var0_0.Init(arg0_7)
	local var0_7 = arg0_7.contextData.backyardView

	arg0_7:initInfo()
	setActive(arg0_7:findTF("frame_for_backyard"), var0_7)
	setActive(arg0_7:findTF("frame"), not var0_7)

	local var1_7

	if var0_7 then
		var1_7 = arg0_7:findTF("frame_for_backyard/right_bg")
	else
		var1_7 = arg0_7:findTF("frame/right_bg")
	end

	arg0_7.btnTFs = {}

	for iter0_7, iter1_7 in ipairs(var1_0) do
		local var2_7 = var1_7:GetChild(iter0_7 - 1)

		setActive(var2_7, true)
		onButton(arg0_7, var2_7, function()
			if iter1_7 == "" then
				return
			end

			if iter1_7 == "OPEN_INFORM" then
				local var0_8 = arg0_7.friend.id .. arg0_7.contextData.msg
				local var1_8 = getProxy(ChatProxy)

				if not table.contains(var1_8.informs, var0_8) then
					arg0_7:openInfromPanel()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("chat_msg_inform"))
				end
			else
				arg0_7:emit(FriendInfoMediator[iter1_7])
			end
		end)

		arg0_7.btnTFs[iter0_7] = var2_7
	end

	setActive(arg0_7.btnTFs[5], arg0_7.contextData.msg)
	setButtonEnabled(arg0_7.btnTFs[2], not arg0_7.friendProxy:isFriend(arg0_7.friend.id))
	arg0_7:updateBlack()

	if arg0_7.contextData.form == NotificationLayer.FORM_BATTLE then
		setActive(arg0_7.btnTFs[3], false)

		local var3_7 = arg0_7:findTF("frame")
		local var4_7 = var3_7.sizeDelta

		var3_7.sizeDelta = Vector2(var4_7.x, var4_7.y - 66.7)
	end

	setActive(arg0_7:findTF("frame/left_bg", false))
end

function var0_0.openInfromPanel(arg0_9)
	setActive(arg0_9.informPanel, true)

	if not arg0_9.isInitInform then
		arg0_9.isInitInform = true

		arg0_9:initInform()
	end
end

function var0_0.initInform(arg0_10)
	arg0_10.informInfoForBackYard = {}

	local var0_10
	local var1_10 = arg0_10.contextData.backyardView

	if var1_10 then
		arg0_10.nameTF.text = i18n("inform_player", arg0_10.friend.name) .. i18n("backyard_theme_inform_them", arg0_10.contextData.msg)

		local var2_10 = require("ShareCfg.InformForBackYardThemeTemplateCfg")

		for iter0_10, iter1_10 in ipairs(var2_10) do
			local var3_10 = cloneTplTo(arg0_10.buttonTpl, arg0_10.toggleContainer)

			var3_10:Find("Label"):GetComponent("Text").text = iter1_10.content

			local var4_10 = false

			onButton(arg0_10, var3_10, function()
				var4_10 = not var4_10

				setActive(var3_10:Find("Background/Checkmark"), var4_10)

				if var4_10 then
					table.insert(arg0_10.informInfoForBackYard, iter0_10)
				elseif table.contains(arg0_10.informInfoForBackYard, iter0_10) then
					table.removebyvalue(arg0_10.informInfoForBackYard, iter0_10)
				end
			end)
		end
	else
		arg0_10.nameTF.text = i18n("inform_player", arg0_10.friend.name)

		local var5_10 = require("ShareCfg.informCfg")

		for iter2_10, iter3_10 in ipairs(var5_10) do
			local var6_10 = cloneTplTo(arg0_10.toggleTpl, arg0_10.toggleContainer)

			var6_10:Find("Label"):GetComponent("Text").text = iter3_10.content

			onToggle(arg0_10, var6_10, function(arg0_12)
				if arg0_12 then
					arg0_10.informInfo = iter3_10.content
				end
			end)
		end
	end

	onButton(arg0_10, arg0_10.confirmBtn, function()
		if not arg0_10.contextData.msg then
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_chat_msg"))

			return
		end

		if var1_10 then
			if #arg0_10.informInfoForBackYard == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			arg0_10:emit(FriendInfoMediator.INFORM_BACKYARD, arg0_10.friend.id, arg0_10.informInfoForBackYard, arg0_10.contextData.msg, arg0_10.friend.name)
		else
			if not arg0_10.informInfo then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			arg0_10:emit(FriendInfoMediator.INFORM, arg0_10.friend.id, arg0_10.informInfo, arg0_10.contextData.msg)
		end
	end)
	onButton(arg0_10, arg0_10.cancelBtn, function()
		arg0_10:closeInfromPanel()
	end)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:closeInfromPanel()
	end)
end

function var0_0.closeInfromPanel(arg0_16)
	setActive(arg0_16.informPanel, false)

	arg0_16.informInfo = nil
end

function var0_0.initInfo(arg0_17)
	assert(arg0_17.friend, "self.friend is nil")

	local var0_17 = pg.ship_data_statistics[arg0_17.friend.icon]

	assert(var0_17, "shipCfg is nil >> id ==" .. arg0_17.friend.icon)

	local var1_17 = pg.ship_skin_template[var0_17.skin_id]

	assert(var1_17, "skinCfg is nil >> id ==" .. var0_17.skin_id)
	LoadSpriteAsync("qicon/" .. var1_17.painting, function(arg0_18)
		if not IsNil(arg0_17.iconTF) then
			if not arg0_18 then
				arg0_17.iconTF.sprite = GetSpriteFromAtlas("heroicon/unknown", "")
			else
				arg0_17.iconTF.sprite = arg0_18
			end
		end
	end)

	for iter0_17 = arg0_17.starsTF.childCount, var0_17.star - 1 do
		cloneTplTo(arg0_17.starTF, arg0_17.starsTF)
	end

	for iter1_17 = 1, var0_17.star do
		local var2_17 = arg0_17.starsTF:GetChild(iter1_17 - 1)

		setActive(var2_17, iter1_17 <= var0_17.star)
	end

	arg0_17.playerNameTF.text = arg0_17.friend.name
	arg0_17.levelTF.text = arg0_17.friend.level

	local var3_17 = SeasonInfo.getMilitaryRank(arg0_17.friend.score, arg0_17.friend.rank)
	local var4_17 = SeasonInfo.getEmblem(arg0_17.friend.score, arg0_17.friend.rank)

	LoadImageSpriteAsync("emblem/" .. var4_17, arg0_17.resumeEmblem)
end

function var0_0.updateBlack(arg0_19)
	local var0_19 = arg0_19.friendProxy:getBlackPlayerById(arg0_19.friend.id) ~= nil

	setActive(findTF(arg0_19.btnTFs[4], "black"), not var0_19)
	setActive(findTF(arg0_19.btnTFs[4], "unblack"), var0_19)
end

function var0_0.willExit(arg0_20)
	return
end

return var0_0
