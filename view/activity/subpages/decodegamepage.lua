local var0 = class("DecodeGamePage", import(".TemplatePage.SkinTemplatePage"))
local var1

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.dayTF = arg0:findTF("Text", arg0.bg):GetComponent(typeof(Text))
	arg0.item = arg0:findTF("items/item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)
	arg0.start = arg0:findTF("AD/start")
	arg0.itemIcon = arg0:findTF("AD/ring/icon")
	arg0.itemLock = arg0:findTF("AD/ring/lock")
	arg0.itemGot = arg0:findTF("AD/ring/got")
	arg0.itemProgressG = arg0:findTF("AD/ring/bar_g")
	arg0.itemProgressB = arg0:findTF("AD/ring/bar_b")
	arg0.red = arg0:findTF("AD/red")
	arg0.number1 = arg0:findTF("AD/1"):GetComponent(typeof(Image))
	arg0.number2 = arg0:findTF("AD/2"):GetComponent(typeof(Image))
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	var1 = arg0.activity:getConfig("config_client").decodeGameId

	onButton(arg0, arg0.start, function()
		pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA,
			callback = function()
				pg.m02:sendNotification(GAME.GO_MINI_GAME, var1)
			end
		})
	end, SFX_PANEL)

	local var0 = Equipment.New({
		id = DecodeGameConst.AWARD[2]
	})

	GetImageSpriteFromAtlasAsync("equips/" .. var0:getConfig("icon"), "", arg0.itemIcon)
end

function var0.GetProgressColor(arg0)
	return "#E6F9FD", "#738285"
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	arg0.dayTF.text = arg0.nday .. "/7"

	pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
		type = MiniGameRequestCommand.REQUEST_HUB_DATA,
		callback = function()
			arg0:UpdateGameProgress()
		end
	})
end

function var0.UpdateGameProgress(arg0)
	local var0 = getProxy(MiniGameProxy)
	local var1 = var0:GetHubByGameId(var1)
	local var2 = var0:GetMiniGameData(var1)
	local var3 = DecodeMiniGameView.GetData(var1, var2)
	local var4 = DecodeGameModel.New()

	var4:SetData(var3)

	local var5 = var4:GetUnlockedCnt()

	if var5 < DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN * DecodeGameConst.MAX_MAP_COUNT then
		setFillAmount(arg0.itemProgressB, var5 * DecodeGameConst.PROGRESS2FILLAMOUMT)
	else
		setFillAmount(arg0.itemProgressB, 1)
	end

	local var6 = {
		0.212,
		0.538,
		1
	}
	local var7 = var4:GetPassWordProgress()
	local var8 = 0

	for iter0, iter1 in ipairs(var7) do
		if iter1 then
			var8 = var8 + 1
		end
	end

	setFillAmount(arg0.itemProgressG, var8 == 0 and 0 or var6[var8])

	local var9 = var4.isFinished

	setActive(arg0.itemLock, not var9)
	setActive(arg0.itemGot, var9)
	arg0:UpdateCanUseCnt(var4.canUseCnt)
	setActive(arg0.red, not var9 and arg0:IsFinishAllTasks())
end

function var0.IsFinishAllTasks(arg0)
	local var0 = arg0.taskGroup[#arg0.taskGroup]

	return _.all(var0, function(arg0)
		return getProxy(TaskProxy):getFinishTaskById(arg0) ~= nil
	end)
end

function var0.UpdateCanUseCnt(arg0, arg1)
	local var0 = math.floor(arg1 / 10)
	local var1 = arg1 % 10

	arg0.number1.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var0)
	arg0.number2.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var1)
	tf(arg0.number1).localPosition = var0 == 1 and Vector3(571, 221.6) or Vector3(551.7, 221.6)
	tf(arg0.number2).localPosition = var1 == 1 and Vector3(644, 221.6) or Vector3(625.5, 221.6)
end

return var0
