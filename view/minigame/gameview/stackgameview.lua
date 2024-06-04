local var0 = class("StackGameView", import("..BaseMiniGameView"))

var0.MINIGAME_HUB_ID = 39
var0.MINIGAME_ID = 47

function var0.getUIName(arg0)
	return "PileGameUI"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("overview/back")
	arg0.scrollrect = arg0:findTF("overview/levels"):GetComponent(typeof(ScrollRect))
	arg0.levelUIlist = UIItemList.New(arg0:findTF("overview/levels/mask/content"), arg0:findTF("overview/levels/mask/content/1"))
	arg0.topArrBtn = arg0:findTF("overview/levels/top")
	arg0.bottomArrBtn = arg0:findTF("overview/levels/bottom")
end

local var1 = 7

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.topArrBtn, function()
		local var0 = arg0.scrollrect.normalizedPosition.y + 1 / (var1 - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.scrollrect, 0, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.bottomArrBtn, function()
		local var0 = arg0.scrollrect.normalizedPosition.y - 1 / (var1 - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.scrollrect, 0, var0)
	end, SFX_PANEL)
	arg0.levelUIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateLevelTr(arg1 + 1, arg2)
		end
	end)
	arg0.levelUIlist:align(var1)

	arg0.controller = PileGameController.New()

	arg0.controller.view:SetUI(arg0._go)

	local var0 = arg0:PackData()

	arg0.controller:SetUp(var0, function(arg0, arg1)
		if arg1 < arg0 then
			arg0:StoreDataToServer({
				arg0
			})
		end

		if arg0:GetMGHubData().count > 0 then
			arg0:SendSuccess(0)
		end
	end)
end

function var0.UpdateLevelTr(arg0, arg1, arg2)
	local var0 = getProxy(MiniGameProxy):GetHubByHubId(var0.MINIGAME_HUB_ID)
	local var1 = arg2:Find("clear")
	local var2 = arg2:Find("unopen")
	local var3 = arg2:Find("award")

	setActive(var1, arg1 <= var0.usedtime)

	local var4 = arg1 > var0.count + var0.usedtime

	setActive(var2, var4)
	setActive(var3, not var4)

	if not var4 then
		local var5 = pg.mini_game[var0.MINIGAME_ID].simple_config_data.drop[arg1]
		local var6 = {
			type = var5[1],
			id = var5[2],
			count = var5[3]
		}

		updateDrop(var3, var6)
		onButton(arg0, var3, function()
			arg0:emit(BaseUI.ON_DROP, var6)
		end, SFX_PANEL)
	end

	arg2:Find("Text"):GetComponent(typeof(Image)).sprite = LoadSprite("ui/minigameui/pile_atlas", "level" .. arg1)
end

function var0.PackData(arg0)
	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = var0 and var0[1] or 0

	return {
		highestScore = var1,
		screen = Vector2(arg0._tf.rect.width, arg0._tf.rect.height)
	}
end

function var0.OnGetAwardDone(arg0, arg1)
	arg0.levelUIlist:align(var1)
end

function var0.onBackPressed(arg0)
	if arg0.controller:onBackPressed() then
		return
	end

	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	arg0.controller:Dispose()
end

return var0
