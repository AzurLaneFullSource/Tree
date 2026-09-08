local var0_0 = class("ReversePacmanTechnologyPlayerSkillView", import("..roleSkill.ReversePacmanTechnologyRoleSkillView"))

function var0_0.Init(arg0_1)
	arg0_1.itemList = {}

	local var0_1 = ReversePacmanTools.GetActivity()

	for iter0_1, iter1_1 in ipairs(var0_1:getConfig("config_client").playerSkillShopIDList) do
		arg0_1.itemList[iter0_1] = arg0_1:GetItemClass().New(Object.Instantiate(arg0_1.uiSkillItem, arg0_1.uiSkillParent), arg0_1, iter1_1)
	end

	setText(arg0_1.uiFrontText, i18n("reverse_pacman_owned"))
	setImageSprite(arg0_1.uiIconImage, GetSpriteFromAtlas(ReversePacmanTools.GetTechnologyPTDrop():getIcon(), ""))
	onButton(arg0_1, arg0_1.uiCurrencyBtn, function()
		local var0_2 = ReversePacmanTools.GetTechnologyPTDrop()

		arg0_1:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanItemPopScene,
			mediator = ReversePacmanItemPopMediator,
			data = {
				dropType = var0_2.type,
				dropID = var0_2.id,
				count = var0_2:getOwnedCount(),
				limitItemGuideID = ReversePacmanTools.GetActivity():getConfig("config_client").pt_link or 240
			}
		}))
	end, SFX_PANEL)
end

function var0_0.GetItemClass(arg0_3)
	return ReversePacmanTechnologyPlayerSkillItem
end

return var0_0
