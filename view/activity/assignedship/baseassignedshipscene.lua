local var0 = class("BaseAssignedShipScene", import("...base.BaseUI"))

var0.TipWords = {
	login_year = "nine_choose_one",
	login_santa = "five_choose_one",
	shrine_year = "seven_choose_one",
	greeting_year = "spring_invited_2021"
}

function var0.getUIName(arg0)
	assert(false)
end

function var0.setItemVO(arg0, arg1)
	arg0.itemVO = arg1
	arg0.idList = arg0.itemVO:getConfig("usage_arg")
	arg0.shipIdList = underscore.map(arg0.idList, function(arg0)
		return pg.item_usage_invitation[arg0].ship_id
	end)
	arg0.style, arg0.title = unpack(arg0.itemVO:getConfig("open_ui"))
	arg0.strTip = var0.TipWords[arg0.style]
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("layer")

	arg0.backBtn = var0:Find("back")
	arg0.confirmBtn = var0:Find("confirm")
	arg0.print = var0:Find("print")
	arg0.rtName = var0:Find("name")
	arg0.rtTitle = var0:Find("title")
	arg0.selectPanel = var0:Find("select_panel/layout")
	arg0.itemList = UIItemList.New(arg0.selectPanel, arg0.selectPanel:Find("item"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		local var0 = arg0.shipIdList[arg1]

		if arg0 == UIItemList.EventUpdate then
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0.style .. "/i_" .. var0, "", arg2)
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0.style .. "/is_" .. var0, "", arg2:Find("selected"))
			onToggle(arg0, arg2, function(arg0)
				if arg0 and arg0.selectTarget ~= arg1 then
					LeanTween.cancel(arg0.print)

					if arg0.rtName then
						LeanTween.cancel(arg0.rtName)
					end

					arg0:setSelectTarget(arg1)
				end
			end, SFX_PANEL)
		end
	end)

	arg0.selectTarget = nil
	arg0.count = 1
	arg0.spList = {}
	arg0.afterAnima = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0, arg0.confirmBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg0.strTip, pg.ship_data_statistics[arg0.selectedShipNumber].name),
			onYes = function()
				arg0:emit(AssignedShipMediator.ON_USE_ITEM, arg0.itemVO.id, arg0.count, {
					arg0.idList[arg0.selectTarget]
				})
			end
		})
	end, SFX_PANEL)
	arg0.itemList:align(#arg0.idList)
	setActive(arg0.rtTitle, arg0.title)

	if arg0.title then
		GetImageSpriteFromAtlasAsync("extra_page/" .. arg0.style .. "/" .. arg0.title, "", arg0.rtTitle, true)
	end

	triggerToggle(arg0.selectPanel:GetChild(0), true)
end

function var0.checkAndSetSprite(arg0, arg1, arg2)
	if arg0.spList[arg1] and arg0.afterAnima[arg1] then
		setImageSprite(arg2, arg0.spList[arg1], true)

		arg2:GetComponent(typeof(Image)).enabled = true
		arg0.spList[arg1] = nil
		arg0.afterAnima[arg1] = nil

		LeanTween.alpha(arg2, 1, 0.3):setFrom(0)
	end
end

function var0.changeShowCharacter(arg0, arg1, arg2, arg3)
	if arg3 then
		LeanTween.alpha(rtf(arg2), 0, 0.3):setOnComplete(System.Action(function()
			arg2:GetComponent(typeof(Image)).enabled = false
			arg0.afterAnima[arg1] = true

			arg0:checkAndSetSprite(arg1, arg2)
		end))
	else
		arg2:GetComponent(typeof(Image)).enabled = false
		arg0.afterAnima[arg1] = true
	end

	GetSpriteFromAtlasAsync("extra_page/" .. arg0.style .. "/" .. arg1, "", function(arg0)
		arg0.spList[arg1] = arg0

		arg0:checkAndSetSprite(arg1, arg2)
	end)
end

function var0.setSelectTarget(arg0, arg1)
	arg0:changeShowCharacter("p_" .. arg0.shipIdList[arg1], arg0.print, arg0.selectTarget)

	if arg0.rtName then
		arg0:changeShowCharacter("n_" .. arg0.shipIdList[arg1], arg0.rtName, arg0.selectTarget)
	end

	arg0.selectTarget = arg1
	arg0.selectedShipNumber = arg0.shipIdList[arg1]
end

function var0.willExit(arg0)
	return
end

return var0
