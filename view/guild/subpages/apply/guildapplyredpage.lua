local var0 = class("GuildApplyRedPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildApplyRedUI"
end

function var0.OnLoaded(arg0)
	arg0.iconTF = findTF(arg0._tf, "panel/frame/policy_container/input_frame/shipicon/icon"):GetComponent(typeof(Image))
	arg0.circle = findTF(arg0._tf, "panel/frame/policy_container/input_frame/shipicon/frame")
	arg0.manifesto = findTF(arg0._tf, "panel/frame/policy_container/input_frame/Text"):GetComponent(typeof(Text))
	arg0.starsTF = findTF(arg0._tf, "panel/frame/policy_container/input_frame/shipicon/stars")
	arg0.starTF = findTF(arg0._tf, "panel/frame/policy_container/input_frame/shipicon/stars/star")
	arg0.applyBtn = findTF(arg0._tf, "panel/frame/confirm_btn")
	arg0.cancelBtn = findTF(arg0._tf, "panel/frame/cancel_btn")
	arg0.nameTF = findTF(arg0._tf, "panel/frame/name"):GetComponent(typeof(Text))
	arg0.levelTF = findTF(arg0._tf, "panel/frame/info/level/Text"):GetComponent(typeof(Text))
	arg0.countTF = findTF(arg0._tf, "panel/frame/info/count/Text"):GetComponent(typeof(Text))
	arg0.flagName = findTF(arg0._tf, "panel/frame/policy_container/name/Text"):GetComponent(typeof(Text))
	arg0.policyTF = findTF(arg0._tf, "panel/frame/policy_container/policy/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.applyBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			limit = 20,
			yesText = "text_confirm",
			type = MSGBOX_TYPE_INPUT,
			placeholder = i18n("guild_request_msg_placeholder"),
			title = i18n("guild_request_msg_title"),
			onYes = function(arg0)
				arg0:emit(JoinGuildMediator.APPLY, arg0.guildVO.id, arg0)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	arg0.guildVO = arg1

	arg0:UpdateApplyPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	var0.super.Show(arg0)
end

function var0.UpdateApplyPanel(arg0)
	local var0 = arg0.guildVO
	local var1 = Ship.New({
		configId = var0:getCommader().icon
	})

	LoadSpriteAsync("QIcon/" .. var1:getPainting(), function(arg0)
		arg0.iconTF.sprite = arg0
	end)

	local var2 = pg.ship_data_statistics[var1.configId]

	arg0.manifesto.text = var0.manifesto

	local var3 = arg0.starsTF.childCount

	for iter0 = var3, var2.star - 1 do
		cloneTplTo(arg0.starTF, arg0.starsTF)
	end

	for iter1 = 1, var3 do
		local var4 = arg0.starsTF:GetChild(iter1 - 1)

		setActive(var4, iter1 <= var2.star)
	end

	arg0.nameTF.text = var0.name
	arg0.levelTF.text = var0.level < 9 and "0" .. var0.level or var0.level
	arg0.countTF.text = var0.memberCount .. "/" .. var0:getMaxMember()
	arg0.flagName.text = var0:getCommader().name
	arg0.policyTF.text = var0:getPolicyName()

	local var5 = var0:getCommader()
	local var6 = AttireFrame.attireFrameRes(var5, var5.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var5.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var6, var6, true, function(arg0)
		if IsNil(arg0._tf) then
			return
		end

		if arg0.circle then
			arg0.name = var6
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var6, var6, arg0)
		end
	end)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr:GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	if arg0.circle.childCount > 0 then
		local var0 = arg0.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0.name, var0.name, var0)
	end
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
