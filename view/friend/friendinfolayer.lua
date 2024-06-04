local var0 = class("FriendInfoLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "FriendInfoUI"
end

function var0.setFriend(arg0, arg1)
	arg0.friend = arg1
end

function var0.setFriendProxy(arg0, arg1)
	arg0.friendProxy = arg1
end

local var1 = {
	"OPEN_RESUME",
	"OPEND_FRIEND",
	"OPEN_BACKYARD",
	"TOGGLE_BLACK",
	"OPEN_INFORM"
}

function var0.init(arg0)
	if arg0.contextData.form == NotificationLayer.FORM_BATTLE then
		setParent(arg0._tf, arg0.contextData.parent)
	elseif arg0.contextData.form == NotificationLayer.FORM_MAIN then
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
			groupName = arg0:getGroupNameFromData(),
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
			groupName = arg0:getGroupNameFromData(),
			weight = LayerWeightConst.SECOND_LAYER
		})
	end

	arg0.frame = arg0:findTF("frame")
	arg0.iconTF = arg0:findTF("frame/left_bg/icon_bg/frame/icon"):GetComponent(typeof(Image))
	arg0.starsTF = arg0:findTF("frame/left_bg/icon_bg/stars")
	arg0.starTF = arg0:findTF("frame/left_bg/icon_bg/stars/star")
	arg0.playerNameTF = arg0:findTF("frame/left_bg/name_bg/Text"):GetComponent(typeof(Text))
	arg0.levelTF = arg0:findTF("frame/left_bg/icon_bg/lv/Text"):GetComponent(typeof(Text))
	arg0.resumeEmblem = arg0:findTF("frame/left_bg/emblem")
	arg0.resumeRank = arg0:findTF("frame/left_bg/emblem/Text"):GetComponent(typeof(Text))
	arg0.informPanel = arg0:findTF("inform_panel")
	arg0.toggleTpl = arg0:findTF("inform_panel/frame/window/main/Toggle")
	arg0.buttonTpl = arg0:findTF("inform_panel/frame/window/main/button")
	arg0.toggleContainer = arg0:findTF("inform_panel/frame/window/main/toggles")
	arg0.confirmBtn = arg0:findTF("frame/window/buttons/confirm_btn", arg0.informPanel)
	arg0.cancelBtn = arg0:findTF("frame/window/buttons/cancel_btn", arg0.informPanel)
	arg0.backBtn = arg0:findTF("inform_panel/frame/window/top/btnBack")
	arg0.nameTF = arg0:findTF("inform_panel/frame/window/name"):GetComponent(typeof(Text))

	if arg0.contextData.pos then
		if arg0.contextData.backyardView then
			local var0 = arg0:findTF("frame_for_backyard")

			var0.position = arg0.contextData.pos
			var0.localPosition = Vector3(var0.localPosition.x, var0.localPosition.y, 0)
		else
			arg0.height = arg0._tf.rect.height
			arg0.frame.position = arg0.contextData.pos

			local var1 = arg0.frame.localPosition
			local var2 = -1 * (arg0.height / 2 - arg0.frame.sizeDelta.y)
			local var3 = var2 >= var1.y and var2 or var1.y

			arg0.frame.localPosition = Vector3(var1.x, var3, 0)
		end
	end
end

function var0.didEnter(arg0)
	arg0:Init()
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
end

function var0.Init(arg0)
	local var0 = arg0.contextData.backyardView

	arg0:initInfo()
	setActive(arg0:findTF("frame_for_backyard"), var0)
	setActive(arg0:findTF("frame"), not var0)

	local var1

	if var0 then
		var1 = arg0:findTF("frame_for_backyard/right_bg")
	else
		var1 = arg0:findTF("frame/right_bg")
	end

	arg0.btnTFs = {}

	for iter0, iter1 in ipairs(var1) do
		local var2 = var1:GetChild(iter0 - 1)

		setActive(var2, true)
		onButton(arg0, var2, function()
			if iter1 == "" then
				return
			end

			if iter1 == "OPEN_INFORM" then
				local var0 = arg0.friend.id .. arg0.contextData.msg
				local var1 = getProxy(ChatProxy)

				if not table.contains(var1.informs, var0) then
					arg0:openInfromPanel()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("chat_msg_inform"))
				end
			else
				arg0:emit(FriendInfoMediator[iter1])
			end
		end)

		arg0.btnTFs[iter0] = var2
	end

	setActive(arg0.btnTFs[5], arg0.contextData.msg)
	setButtonEnabled(arg0.btnTFs[2], not arg0.friendProxy:isFriend(arg0.friend.id))
	arg0:updateBlack()

	if arg0.contextData.form == NotificationLayer.FORM_BATTLE then
		setActive(arg0.btnTFs[3], false)

		local var3 = arg0:findTF("frame")
		local var4 = var3.sizeDelta

		var3.sizeDelta = Vector2(var4.x, var4.y - 66.7)
	end

	setActive(arg0:findTF("frame/left_bg", false))
end

function var0.openInfromPanel(arg0)
	setActive(arg0.informPanel, true)

	if not arg0.isInitInform then
		arg0.isInitInform = true

		arg0:initInform()
	end
end

function var0.initInform(arg0)
	arg0.informInfoForBackYard = {}

	local var0
	local var1 = arg0.contextData.backyardView

	if var1 then
		arg0.nameTF.text = i18n("inform_player", arg0.friend.name) .. i18n("backyard_theme_inform_them", arg0.contextData.msg)

		local var2 = require("ShareCfg.InformForBackYardThemeTemplateCfg")

		for iter0, iter1 in ipairs(var2) do
			local var3 = cloneTplTo(arg0.buttonTpl, arg0.toggleContainer)

			var3:Find("Label"):GetComponent("Text").text = iter1.content

			local var4 = false

			onButton(arg0, var3, function()
				var4 = not var4

				setActive(var3:Find("Background/Checkmark"), var4)

				if var4 then
					table.insert(arg0.informInfoForBackYard, iter0)
				elseif table.contains(arg0.informInfoForBackYard, iter0) then
					table.removebyvalue(arg0.informInfoForBackYard, iter0)
				end
			end)
		end
	else
		arg0.nameTF.text = i18n("inform_player", arg0.friend.name)

		local var5 = require("ShareCfg.informCfg")

		for iter2, iter3 in ipairs(var5) do
			local var6 = cloneTplTo(arg0.toggleTpl, arg0.toggleContainer)

			var6:Find("Label"):GetComponent("Text").text = iter3.content

			onToggle(arg0, var6, function(arg0)
				if arg0 then
					arg0.informInfo = iter3.content
				end
			end)
		end
	end

	onButton(arg0, arg0.confirmBtn, function()
		if not arg0.contextData.msg then
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_chat_msg"))

			return
		end

		if var1 then
			if #arg0.informInfoForBackYard == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			arg0:emit(FriendInfoMediator.INFORM_BACKYARD, arg0.friend.id, arg0.informInfoForBackYard, arg0.contextData.msg, arg0.friend.name)
		else
			if not arg0.informInfo then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			arg0:emit(FriendInfoMediator.INFORM, arg0.friend.id, arg0.informInfo, arg0.contextData.msg)
		end
	end)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:closeInfromPanel()
	end)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeInfromPanel()
	end)
end

function var0.closeInfromPanel(arg0)
	setActive(arg0.informPanel, false)

	arg0.informInfo = nil
end

function var0.initInfo(arg0)
	assert(arg0.friend, "self.friend is nil")

	local var0 = pg.ship_data_statistics[arg0.friend.icon]

	assert(var0, "shipCfg is nil >> id ==" .. arg0.friend.icon)

	local var1 = pg.ship_skin_template[var0.skin_id]

	assert(var1, "skinCfg is nil >> id ==" .. var0.skin_id)
	LoadSpriteAsync("qicon/" .. var1.painting, function(arg0)
		if not IsNil(arg0.iconTF) then
			if not arg0 then
				arg0.iconTF.sprite = GetSpriteFromAtlas("heroicon/unknown", "")
			else
				arg0.iconTF.sprite = arg0
			end
		end
	end)

	for iter0 = arg0.starsTF.childCount, var0.star - 1 do
		cloneTplTo(arg0.starTF, arg0.starsTF)
	end

	for iter1 = 1, var0.star do
		local var2 = arg0.starsTF:GetChild(iter1 - 1)

		setActive(var2, iter1 <= var0.star)
	end

	arg0.playerNameTF.text = arg0.friend.name
	arg0.levelTF.text = arg0.friend.level

	local var3 = SeasonInfo.getMilitaryRank(arg0.friend.score, arg0.friend.rank)
	local var4 = SeasonInfo.getEmblem(arg0.friend.score, arg0.friend.rank)

	LoadImageSpriteAsync("emblem/" .. var4, arg0.resumeEmblem)
end

function var0.updateBlack(arg0)
	local var0 = arg0.friendProxy:getBlackPlayerById(arg0.friend.id) ~= nil

	setActive(findTF(arg0.btnTFs[4], "black"), not var0)
	setActive(findTF(arg0.btnTFs[4], "unblack"), var0)
end

function var0.willExit(arg0)
	return
end

return var0
