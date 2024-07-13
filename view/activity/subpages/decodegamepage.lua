local var0_0 = class("DecodeGamePage", import(".TemplatePage.SkinTemplatePage"))
local var1_0

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.dayTF = arg0_1:findTF("Text", arg0_1.bg):GetComponent(typeof(Text))
	arg0_1.item = arg0_1:findTF("items/item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.start = arg0_1:findTF("AD/start")
	arg0_1.itemIcon = arg0_1:findTF("AD/ring/icon")
	arg0_1.itemLock = arg0_1:findTF("AD/ring/lock")
	arg0_1.itemGot = arg0_1:findTF("AD/ring/got")
	arg0_1.itemProgressG = arg0_1:findTF("AD/ring/bar_g")
	arg0_1.itemProgressB = arg0_1:findTF("AD/ring/bar_b")
	arg0_1.red = arg0_1:findTF("AD/red")
	arg0_1.number1 = arg0_1:findTF("AD/1"):GetComponent(typeof(Image))
	arg0_1.number2 = arg0_1:findTF("AD/2"):GetComponent(typeof(Image))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	var1_0 = arg0_2.activity:getConfig("config_client").decodeGameId

	onButton(arg0_2, arg0_2.start, function()
		pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA,
			callback = function()
				pg.m02:sendNotification(GAME.GO_MINI_GAME, var1_0)
			end
		})
	end, SFX_PANEL)

	local var0_2 = Equipment.New({
		id = DecodeGameConst.AWARD[2]
	})

	GetImageSpriteFromAtlasAsync("equips/" .. var0_2:getConfig("icon"), "", arg0_2.itemIcon)
end

function var0_0.GetProgressColor(arg0_5)
	return "#E6F9FD", "#738285"
end

function var0_0.OnUpdateFlush(arg0_6)
	var0_0.super.OnUpdateFlush(arg0_6)

	arg0_6.dayTF.text = arg0_6.nday .. "/7"

	pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
		type = MiniGameRequestCommand.REQUEST_HUB_DATA,
		callback = function()
			arg0_6:UpdateGameProgress()
		end
	})
end

function var0_0.UpdateGameProgress(arg0_8)
	local var0_8 = getProxy(MiniGameProxy)
	local var1_8 = var0_8:GetHubByGameId(var1_0)
	local var2_8 = var0_8:GetMiniGameData(var1_0)
	local var3_8 = DecodeMiniGameView.GetData(var1_8, var2_8)
	local var4_8 = DecodeGameModel.New()

	var4_8:SetData(var3_8)

	local var5_8 = var4_8:GetUnlockedCnt()

	if var5_8 < DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN * DecodeGameConst.MAX_MAP_COUNT then
		setFillAmount(arg0_8.itemProgressB, var5_8 * DecodeGameConst.PROGRESS2FILLAMOUMT)
	else
		setFillAmount(arg0_8.itemProgressB, 1)
	end

	local var6_8 = {
		0.212,
		0.538,
		1
	}
	local var7_8 = var4_8:GetPassWordProgress()
	local var8_8 = 0

	for iter0_8, iter1_8 in ipairs(var7_8) do
		if iter1_8 then
			var8_8 = var8_8 + 1
		end
	end

	setFillAmount(arg0_8.itemProgressG, var8_8 == 0 and 0 or var6_8[var8_8])

	local var9_8 = var4_8.isFinished

	setActive(arg0_8.itemLock, not var9_8)
	setActive(arg0_8.itemGot, var9_8)
	arg0_8:UpdateCanUseCnt(var4_8.canUseCnt)
	setActive(arg0_8.red, not var9_8 and arg0_8:IsFinishAllTasks())
end

function var0_0.IsFinishAllTasks(arg0_9)
	local var0_9 = arg0_9.taskGroup[#arg0_9.taskGroup]

	return _.all(var0_9, function(arg0_10)
		return getProxy(TaskProxy):getFinishTaskById(arg0_10) ~= nil
	end)
end

function var0_0.UpdateCanUseCnt(arg0_11, arg1_11)
	local var0_11 = math.floor(arg1_11 / 10)
	local var1_11 = arg1_11 % 10

	arg0_11.number1.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var0_11)
	arg0_11.number2.sprite = GetSpriteFromAtlas("ui/DecodeGameNumber_atlas", var1_11)
	tf(arg0_11.number1).localPosition = var0_11 == 1 and Vector3(571, 221.6) or Vector3(551.7, 221.6)
	tf(arg0_11.number2).localPosition = var1_11 == 1 and Vector3(644, 221.6) or Vector3(625.5, 221.6)
end

return var0_0
