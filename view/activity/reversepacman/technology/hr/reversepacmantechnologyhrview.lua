local var0_0 = class("ReversePacmanTechnologyHrView", import("view.base.BasePanel"))

var0_0.GIFT_SUCCESS = "ReversePacmanTechnologyHrView::GIFT_SUCCESS"
var0_0.STORY_SELECTED_OPTIONAL = "ReversePacmanTechnologyHrView::STORY_SELECTED_OPTIONAL"
var0_0.STORY_ADD_FAVORABILITY = "ReversePacmanTechnologyHrView::STORY_ADD_FAVORABILITY"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
	arg0_1:didEnter()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiFrontText, i18n("reverse_pacman_owned"))

	local var0_2 = ReversePacmanTools.GetGiftItemID()
	local var1_2 = Drop.New({
		type = DROP_TYPE_VITEM,
		id = var0_2
	})

	setImageSprite(arg0_2.uiIconImage, GetSpriteFromAtlas(var1_2:getIcon(), ""))
	onButton(arg0_2, arg0_2.uiCurrencyBtn, function()
		local var0_3 = Drop.New({
			type = DROP_TYPE_VITEM,
			id = var0_2
		})

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanItemPopScene,
			mediator = ReversePacmanItemPopMediator,
			data = {
				dropType = var0_3.type,
				dropID = var0_3.id,
				count = ReversePacmanTools.GetItemCnt(var0_2),
				limitItemGuideID = ReversePacmanTools.GetActivity():getConfig("config_client").gift_link or 239
			}
		}))
	end, SFX_PANEL)

	arg0_2.uiScrollView = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiListTf, ReversePacmanTechnologyHrItem)
end

function var0_0.didEnter(arg0_4)
	local var0_4 = ReversePacmanTools.GetActivity()
	local var1_4 = var0_4:getConfig("config_client").chasing_char

	arg0_4.roleIDList = Clone(var1_4)

	local var2_4 = var0_4:GetFavorabilityList()

	table.sort(arg0_4.roleIDList, function(arg0_5, arg1_5)
		local var0_5 = ReversePacmanTools.IsUnlockRole(arg0_5)

		if var0_5 ~= ReversePacmanTools.IsUnlockRole(arg1_5) then
			return var0_5 == true
		else
			return table.keyof(var1_4, arg0_5) < table.keyof(var1_4, arg1_5)
		end
	end)
	arg0_4.uiScrollView:StartScroll(#arg0_4.roleIDList)

	arg0_4.eventIDList = {
		arg0_4:bind(var0_0.GIFT_SUCCESS, handler(arg0_4, arg0_4.OnGiftSuccess)),
		arg0_4:bind(var0_0.STORY_SELECTED_OPTIONAL, handler(arg0_4, arg0_4.OnStorySelectedOptional)),
		arg0_4:bind(var0_0.STORY_ADD_FAVORABILITY, handler(arg0_4, arg0_4.OnSotryAddFavorablity))
	}

	local var3_4 = ReversePacmanTools.GetFavorabilityUnreadyStory()

	if #var3_4 > 0 then
		local var4_4 = {}

		for iter0_4, iter1_4 in ipairs(var3_4) do
			table.insert(var4_4, function(arg0_6)
				arg0_4:PlayFavorabilityStory(iter1_4, arg0_6)
			end)
		end

		seriesAsync(var4_4, function()
			return
		end)
	end
end

function var0_0.Show(arg0_8)
	arg0_8:RefreshCurrency()
	arg0_8.uiScrollView:Refresh()
end

function var0_0.RefreshCurrency(arg0_9)
	local var0_9 = ReversePacmanTools.GetGiftItemID()

	setText(arg0_9.uiGiftCntText, i18n("reverse_pacman_count", ReversePacmanTools.GetItemCnt(var0_9)))
end

function var0_0.IndexItem(arg0_10, arg1_10, arg2_10)
	arg2_10:didEnter(arg0_10.roleIDList[arg1_10])
end

function var0_0.OnGiftSuccess(arg0_11, arg1_11, arg2_11)
	arg0_11.uiScrollView:Refresh()

	local var0_11 = pg.activity_chasing_character[arg2_11]

	pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_favourite_increased", HXSet.hxLan(var0_11.name)))
	arg0_11:PlayFavorabilityStory(arg2_11)
end

function var0_0.PlayFavorabilityStory(arg0_12, arg1_12, arg2_12)
	arg0_12:RefreshCurrency()

	local var0_12 = ReversePacmanTools.GetUpgradeFavorability(arg1_12)

	if var0_12 ~= 0 then
		local var1_12 = pg.activity_chasing_character[arg1_12]
		local var2_12 = var1_12.love_level_show[var0_12][1]

		arg0_12.storyRoleID = arg1_12
		arg0_12.storyOptionalFlag = var1_12.love_level_show[var0_12][2]

		pg.NewStoryMgr.GetInstance():Play(var2_12, function()
			existCall(arg2_12)
		end)
	end
end

function var0_0.OnStorySelectedOptional(arg0_14, arg1_14, arg2_14)
	if arg2_14.optionalFlag == arg0_14.storyOptionalFlag then
		arg0_14:emit(ReversePacmanTechnologyMediator.CMD_SELECTED_OPTIONAL, {
			roleID = arg0_14.storyRoleID
		})
	end
end

function var0_0.OnSotryAddFavorablity(arg0_15, arg1_15, arg2_15)
	local var0_15 = pg.activity_chasing_character[arg2_15]

	pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_favourite_increased", HXSet.hxLan(var0_15.name)))
	arg0_15.uiScrollView:Refresh()
end

function var0_0.willExit(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.eventIDList) do
		arg0_16:disconnect(iter1_16)
	end

	arg0_16.eventIDList = nil

	arg0_16:detach()
	arg0_16.uiScrollView:Dispose()

	arg0_16.uiScrollView = nil
end

return var0_0
