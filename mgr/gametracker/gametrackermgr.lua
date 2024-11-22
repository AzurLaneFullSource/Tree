pg = pg or {}
pg.GameTrackerMgr = singletonClass("GameTrackerMgr")

local var0_0 = pg.GameTrackerMgr

GameTrackerBuilder = import("Mgr.GameTracker.GameTrackerBuilder")

local var1_0 = 300
local var2_0 = 20
local var3_0 = "GameTrackerMgr"
local var4_0 = "^"

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.readBuffer = {}
	arg0_1.writeBuffer = {}
	arg0_1.duration = var1_0
	arg0_1.passed = 0

	arg0_1:SetUp()
	arg1_1()
end

function var0_0.Record(arg0_2, arg1_2)
	table.insert(arg0_2.readBuffer, arg1_2)
	arg0_2:Cache()

	if #arg0_2.readBuffer >= var2_0 then
		arg0_2:Synchronization()
	end
end

function var0_0.Synchronization(arg0_3)
	arg0_3.passed = 0

	arg0_3:Send()
end

function var0_0.Dispose(arg0_4)
	if arg0_4.handle then
		UpdateBeat:RemoveListener(arg0_4.handle)
	end

	arg0_4.readBuffer = {}
	arg0_4.writeBuffer = {}
	arg0_4.passed = 0
end

function var0_0.SetUp(arg0_5)
	if not arg0_5.handle then
		arg0_5.handle = UpdateBeat:CreateListener(arg0_5.Update, arg0_5)
	end

	UpdateBeat:AddListener(arg0_5.handle)
end

function var0_0.Update(arg0_6)
	arg0_6.passed = arg0_6.passed + Time.deltaTime

	if arg0_6.passed >= arg0_6.duration then
		arg0_6.passed = 0

		arg0_6:Synchronization()
	end
end

function var0_0.Send(arg0_7)
	if #arg0_7.readBuffer <= 0 then
		return
	end

	if not pg.ConnectionMgr.GetInstance():isConnected() then
		return
	end

	arg0_7:FillBuffer()
	arg0_7:ClearCache()
	pg.m02:sendNotification(GAME.GAME_TRACK, {
		infos = arg0_7.writeBuffer
	})
end

function var0_0.FillBuffer(arg0_8)
	arg0_8.writeBuffer = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.readBuffer) do
		table.insert(arg0_8.writeBuffer, iter1_8)
	end

	arg0_8.readBuffer = {}
end

function var0_0.Cache(arg0_9)
	local var0_9 = arg0_9.readBuffer or {}

	if #var0_9 <= 0 then
		return
	end

	local var1_9 = _.map(var0_9, function(arg0_10)
		return GameTrackerBuilder.SerializedItem(arg0_10)
	end)
	local var2_9 = table.concat(var1_9, var4_0)
	local var3_9 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(var3_0 .. var3_9, var2_9)
	PlayerPrefs.Save()
end

function var0_0.ClearCache(arg0_11)
	local var0_11 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(var3_0 .. var0_11, "")
	PlayerPrefs.Save()
end

function var0_0.FetchCache(arg0_12)
	local var0_12 = getProxy(PlayerProxy):getRawData().id
	local var1_12 = PlayerPrefs.GetString(var3_0 .. var0_12, "")

	if not var1_12 or var1_12 == "" then
		return
	end

	arg0_12.readBuffer = {}

	local var2_12 = string.split(var1_12, var4_0)
	local var3_12 = _.map(var2_12, function(arg0_13)
		return GameTrackerBuilder.DeSerializedItem(arg0_13)
	end)

	for iter0_12, iter1_12 in ipairs(var3_12) do
		if iter1_12 then
			table.insert(arg0_12.readBuffer, 1, iter1_12)
		end
	end
end
