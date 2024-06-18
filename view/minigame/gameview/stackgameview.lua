local var0_0 = class("StackGameView", import("..BaseMiniGameView"))

var0_0.MINIGAME_HUB_ID = 39
var0_0.MINIGAME_ID = 47

function var0_0.getUIName(arg0_1)
	return "PileGameUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("overview/back")
	arg0_2.scrollrect = arg0_2:findTF("overview/levels"):GetComponent(typeof(ScrollRect))
	arg0_2.levelUIlist = UIItemList.New(arg0_2:findTF("overview/levels/mask/content"), arg0_2:findTF("overview/levels/mask/content/1"))
	arg0_2.topArrBtn = arg0_2:findTF("overview/levels/top")
	arg0_2.bottomArrBtn = arg0_2:findTF("overview/levels/bottom")
end

local var1_0 = 7

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.topArrBtn, function()
		local var0_5 = arg0_3.scrollrect.normalizedPosition.y + 1 / (var1_0 - 4)

		if var0_5 > 1 then
			var0_5 = 1
		end

		scrollTo(arg0_3.scrollrect, 0, var0_5)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.bottomArrBtn, function()
		local var0_6 = arg0_3.scrollrect.normalizedPosition.y - 1 / (var1_0 - 4)

		if var0_6 < 0 then
			var0_6 = 0
		end

		scrollTo(arg0_3.scrollrect, 0, var0_6)
	end, SFX_PANEL)
	arg0_3.levelUIlist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_3:UpdateLevelTr(arg1_7 + 1, arg2_7)
		end
	end)
	arg0_3.levelUIlist:align(var1_0)

	arg0_3.controller = PileGameController.New()

	arg0_3.controller.view:SetUI(arg0_3._go)

	local var0_3 = arg0_3:PackData()

	arg0_3.controller:SetUp(var0_3, function(arg0_8, arg1_8)
		if arg1_8 < arg0_8 then
			arg0_3:StoreDataToServer({
				arg0_8
			})
		end

		if arg0_3:GetMGHubData().count > 0 then
			arg0_3:SendSuccess(0)
		end
	end)
end

function var0_0.UpdateLevelTr(arg0_9, arg1_9, arg2_9)
	local var0_9 = getProxy(MiniGameProxy):GetHubByHubId(var0_0.MINIGAME_HUB_ID)
	local var1_9 = arg2_9:Find("clear")
	local var2_9 = arg2_9:Find("unopen")
	local var3_9 = arg2_9:Find("award")

	setActive(var1_9, arg1_9 <= var0_9.usedtime)

	local var4_9 = arg1_9 > var0_9.count + var0_9.usedtime

	setActive(var2_9, var4_9)
	setActive(var3_9, not var4_9)

	if not var4_9 then
		local var5_9 = pg.mini_game[var0_0.MINIGAME_ID].simple_config_data.drop[arg1_9]
		local var6_9 = {
			type = var5_9[1],
			id = var5_9[2],
			count = var5_9[3]
		}

		updateDrop(var3_9, var6_9)
		onButton(arg0_9, var3_9, function()
			arg0_9:emit(BaseUI.ON_DROP, var6_9)
		end, SFX_PANEL)
	end

	arg2_9:Find("Text"):GetComponent(typeof(Image)).sprite = LoadSprite("ui/minigameui/pile_atlas", "level" .. arg1_9)
end

function var0_0.PackData(arg0_11)
	local var0_11 = arg0_11:GetMGData():GetRuntimeData("elements")
	local var1_11 = var0_11 and var0_11[1] or 0

	return {
		highestScore = var1_11,
		screen = Vector2(arg0_11._tf.rect.width, arg0_11._tf.rect.height)
	}
end

function var0_0.OnGetAwardDone(arg0_12, arg1_12)
	arg0_12.levelUIlist:align(var1_0)
end

function var0_0.onBackPressed(arg0_13)
	if arg0_13.controller:onBackPressed() then
		return
	end

	arg0_13:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_14)
	arg0_14.controller:Dispose()
end

return var0_0
