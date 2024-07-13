local var0_0 = class("GuildApplyRedPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildApplyRedUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.iconTF = findTF(arg0_2._tf, "panel/frame/policy_container/input_frame/shipicon/icon"):GetComponent(typeof(Image))
	arg0_2.circle = findTF(arg0_2._tf, "panel/frame/policy_container/input_frame/shipicon/frame")
	arg0_2.manifesto = findTF(arg0_2._tf, "panel/frame/policy_container/input_frame/Text"):GetComponent(typeof(Text))
	arg0_2.starsTF = findTF(arg0_2._tf, "panel/frame/policy_container/input_frame/shipicon/stars")
	arg0_2.starTF = findTF(arg0_2._tf, "panel/frame/policy_container/input_frame/shipicon/stars/star")
	arg0_2.applyBtn = findTF(arg0_2._tf, "panel/frame/confirm_btn")
	arg0_2.cancelBtn = findTF(arg0_2._tf, "panel/frame/cancel_btn")
	arg0_2.nameTF = findTF(arg0_2._tf, "panel/frame/name"):GetComponent(typeof(Text))
	arg0_2.levelTF = findTF(arg0_2._tf, "panel/frame/info/level/Text"):GetComponent(typeof(Text))
	arg0_2.countTF = findTF(arg0_2._tf, "panel/frame/info/count/Text"):GetComponent(typeof(Text))
	arg0_2.flagName = findTF(arg0_2._tf, "panel/frame/policy_container/name/Text"):GetComponent(typeof(Text))
	arg0_2.policyTF = findTF(arg0_2._tf, "panel/frame/policy_container/policy/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.applyBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			limit = 20,
			yesText = "text_confirm",
			type = MSGBOX_TYPE_INPUT,
			placeholder = i18n("guild_request_msg_placeholder"),
			title = i18n("guild_request_msg_title"),
			onYes = function(arg0_5)
				arg0_3:emit(JoinGuildMediator.APPLY, arg0_3.guildVO.id, arg0_5)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	arg0_7.guildVO = arg1_7

	arg0_7:UpdateApplyPanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	var0_0.super.Show(arg0_7)
end

function var0_0.UpdateApplyPanel(arg0_8)
	local var0_8 = arg0_8.guildVO
	local var1_8 = Ship.New({
		configId = var0_8:getCommader().icon
	})

	LoadSpriteAsync("QIcon/" .. var1_8:getPainting(), function(arg0_9)
		arg0_8.iconTF.sprite = arg0_9
	end)

	local var2_8 = pg.ship_data_statistics[var1_8.configId]

	arg0_8.manifesto.text = var0_8.manifesto

	local var3_8 = arg0_8.starsTF.childCount

	for iter0_8 = var3_8, var2_8.star - 1 do
		cloneTplTo(arg0_8.starTF, arg0_8.starsTF)
	end

	for iter1_8 = 1, var3_8 do
		local var4_8 = arg0_8.starsTF:GetChild(iter1_8 - 1)

		setActive(var4_8, iter1_8 <= var2_8.star)
	end

	arg0_8.nameTF.text = var0_8.name
	arg0_8.levelTF.text = var0_8.level < 9 and "0" .. var0_8.level or var0_8.level
	arg0_8.countTF.text = var0_8.memberCount .. "/" .. var0_8:getMaxMember()
	arg0_8.flagName.text = var0_8:getCommader().name
	arg0_8.policyTF.text = var0_8:getPolicyName()

	local var5_8 = var0_8:getCommader()
	local var6_8 = AttireFrame.attireFrameRes(var5_8, var5_8.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var5_8.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var6_8, var6_8, true, function(arg0_10)
		if IsNil(arg0_8._tf) then
			return
		end

		if arg0_8.circle then
			arg0_10.name = var6_8
			findTF(arg0_10.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_10, arg0_8.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var6_8, var6_8, arg0_10)
		end
	end)
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
	pg.UIMgr:GetInstance():UnblurPanel(arg0_11._tf, arg0_11._parentTf)

	if arg0_11.circle.childCount > 0 then
		local var0_11 = arg0_11.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_11.name, var0_11.name, var0_11)
	end
end

function var0_0.OnDestroy(arg0_12)
	if arg0_12:isShowing() then
		arg0_12:Hide()
	end
end

return var0_0
