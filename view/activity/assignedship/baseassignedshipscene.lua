local var0_0 = class("BaseAssignedShipScene", import("...base.BaseUI"))

var0_0.TipWords = {
	login_year = "nine_choose_one",
	login_santa = "five_choose_one",
	shrine_year = "seven_choose_one",
	greeting_year = "spring_invited_2021"
}

function var0_0.getUIName(arg0_1)
	assert(false)
end

function var0_0.setItemVO(arg0_2, arg1_2)
	arg0_2.itemVO = arg1_2
	arg0_2.idList = arg0_2.itemVO:getConfig("usage_arg")
	arg0_2.shipIdList = underscore.map(arg0_2.idList, function(arg0_3)
		return pg.item_usage_invitation[arg0_3].ship_id
	end)
	arg0_2.style, arg0_2.title = unpack(arg0_2.itemVO:getConfig("open_ui"))
	arg0_2.strTip = var0_0.TipWords[arg0_2.style]
end

function var0_0.init(arg0_4)
	local var0_4 = arg0_4._tf:Find("layer")

	arg0_4.backBtn = var0_4:Find("back")
	arg0_4.confirmBtn = var0_4:Find("confirm")
	arg0_4.print = var0_4:Find("print")
	arg0_4.rtName = var0_4:Find("name")
	arg0_4.rtTitle = var0_4:Find("title")
	arg0_4.selectPanel = var0_4:Find("select_panel/layout")
	arg0_4.itemList = UIItemList.New(arg0_4.selectPanel, arg0_4.selectPanel:Find("item"))

	arg0_4.itemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		local var0_5 = arg0_4.shipIdList[arg1_5]

		if arg0_5 == UIItemList.EventUpdate then
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0_4.style .. "/i_" .. var0_5, "", arg2_5)
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0_4.style .. "/is_" .. var0_5, "", arg2_5:Find("selected"))
			onToggle(arg0_4, arg2_5, function(arg0_6)
				if arg0_6 and arg0_4.selectTarget ~= arg1_5 then
					LeanTween.cancel(arg0_4.print)

					if arg0_4.rtName then
						LeanTween.cancel(arg0_4.rtName)
					end

					arg0_4:setSelectTarget(arg1_5)
				end
			end, SFX_PANEL)
		end
	end)

	arg0_4.selectTarget = nil
	arg0_4.count = 1
	arg0_4.spList = {}
	arg0_4.afterAnima = {}
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg0_7.strTip, pg.ship_data_statistics[arg0_7.selectedShipNumber].name),
			onYes = function()
				arg0_7:emit(AssignedShipMediator.ON_USE_ITEM, arg0_7.itemVO.id, arg0_7.count, {
					arg0_7.idList[arg0_7.selectTarget]
				})
			end
		})
	end, SFX_PANEL)
	arg0_7.itemList:align(#arg0_7.idList)
	setActive(arg0_7.rtTitle, arg0_7.title)

	if arg0_7.title then
		GetImageSpriteFromAtlasAsync("extra_page/" .. arg0_7.style .. "/" .. arg0_7.title, "", arg0_7.rtTitle, true)
	end

	triggerToggle(arg0_7.selectPanel:GetChild(0), true)
end

function var0_0.checkAndSetSprite(arg0_11, arg1_11, arg2_11)
	if arg0_11.spList[arg1_11] and arg0_11.afterAnima[arg1_11] then
		setImageSprite(arg2_11, arg0_11.spList[arg1_11], true)

		arg2_11:GetComponent(typeof(Image)).enabled = true
		arg0_11.spList[arg1_11] = nil
		arg0_11.afterAnima[arg1_11] = nil

		LeanTween.alpha(arg2_11, 1, 0.3):setFrom(0)
	end
end

function var0_0.changeShowCharacter(arg0_12, arg1_12, arg2_12, arg3_12)
	if arg3_12 then
		LeanTween.alpha(rtf(arg2_12), 0, 0.3):setOnComplete(System.Action(function()
			arg2_12:GetComponent(typeof(Image)).enabled = false
			arg0_12.afterAnima[arg1_12] = true

			arg0_12:checkAndSetSprite(arg1_12, arg2_12)
		end))
	else
		arg2_12:GetComponent(typeof(Image)).enabled = false
		arg0_12.afterAnima[arg1_12] = true
	end

	GetSpriteFromAtlasAsync("extra_page/" .. arg0_12.style .. "/" .. arg1_12, "", function(arg0_14)
		arg0_12.spList[arg1_12] = arg0_14

		arg0_12:checkAndSetSprite(arg1_12, arg2_12)
	end)
end

function var0_0.setSelectTarget(arg0_15, arg1_15)
	arg0_15:changeShowCharacter("p_" .. arg0_15.shipIdList[arg1_15], arg0_15.print, arg0_15.selectTarget)

	if arg0_15.rtName then
		arg0_15:changeShowCharacter("n_" .. arg0_15.shipIdList[arg1_15], arg0_15.rtName, arg0_15.selectTarget)
	end

	arg0_15.selectTarget = arg1_15
	arg0_15.selectedShipNumber = arg0_15.shipIdList[arg1_15]
end

function var0_0.willExit(arg0_16)
	return
end

return var0_0
