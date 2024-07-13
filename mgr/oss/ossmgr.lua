pg = pg or {}
pg.OSSMgr = singletonClass("OSSMgr")

local var0_0 = pg.OSSMgr

function var0_0.Ctor(arg0_1)
	if PLATFORM_CODE == PLATFORM_CH then
		arg0_1.instance = OSSStarter.ins
	end

	arg0_1.isIninted = false

	if arg0_1.instance then
		ReflectionHelp.RefSetField(typeof("OSSStarter"), "debug", arg0_1.instance, false)
	end
end

function var0_0.InitConfig(arg0_2)
	if PLATFORM_CODE == PLATFORM_CH then
		OSS_STS_URL = ""
		OSS_ENDPOINT = "oss-cn-hangzhou.aliyuncs.com"
		OSSBUCKETNAME = "blhx-dorm-oss"

		local var0_2 = pg.SdkMgr.GetInstance():GetChannelUID()
		local var1_2 = var0_2 == "cps" or var0_2 == "yun" or var0_2 == "0"

		if getProxy(UserProxy):GetCacheGatewayInServerLogined() == PLATFORM_IPHONEPLAYER then
			FOLDERNAME = "dorm_ios/"
		elseif var1_2 then
			FOLDERNAME = "dorm_bili/"
		else
			FOLDERNAME = "dorm_uo/"
		end

		print("FOLDERNAME: ", FOLDERNAME)
	elseif PLATFORM_CODE == PLATFORM_US then
		OSS_STS_URL = ""
		OSS_ENDPOINT = "oss-us-east-1.aliyuncs.com"
		OSSBUCKETNAME = "blhx-photo"
		FOLDERNAME = "dorm_us/"
	elseif PLATFORM_CODE == PLATFORM_CHT then
		OSS_STS_URL = ""
		OSS_ENDPOINT = "oss-ap-southeast-1.aliyuncs.com"
		OSSBUCKETNAME = "blhx-gameupload-sts"
		FOLDERNAME = "dorm_tw/"
	elseif PLATFORM_CODE == PLATFORM_KR then
		OSS_STS_URL = ""
		OSS_ENDPOINT = "ap-northeast-2"
		OSSBUCKETNAME = "blhx-s3-houzhai-upload"
		FOLDERNAME = "dorm_kr/"
	elseif PLATFORM_CODE == PLATFORM_JP then
		OSS_STS_URL = ""
		OSS_ENDPOINT = "ap-northeast-1"
		OSSBUCKETNAME = "blhx-dorm-jp"
		FOLDERNAME = "dorm_jp/"
	end
end

function var0_0.Init(arg0_3)
	arg0_3:InitConfig()

	if not arg0_3.isIninted then
		arg0_3.isIninted = true

		arg0_3:InitClinet()
	end
end

function var0_0.InitClinet(arg0_4, arg1_4)
	if not arg0_4.instance then
		return
	end

	local var0_4 = arg0_4.instance.initMode

	local function var1_4(arg0_5, arg1_5)
		arg0_4:AddExpireTimer(arg1_5)
		arg0_4.instance:InitWithArgs(unpack(arg0_5))
	end

	pg.m02:sendNotification(GAME.GET_OSS_ARGS, {
		mode = var0_4,
		callback = var1_4
	})
end

function var0_0.UpdateLoad(arg0_6, arg1_6, arg2_6, arg3_6)
	if not arg0_6.instance then
		arg3_6()

		return
	end

	local var0_6 = OSSBUCKETNAME

	arg0_6.instance:UpdateLoad(var0_6, FOLDERNAME .. arg1_6, arg2_6, arg3_6)
end

function var0_0.AsynUpdateLoad(arg0_7, arg1_7, arg2_7, arg3_7)
	if not arg0_7.instance then
		arg3_7()

		return
	end

	local var0_7 = OSSBUCKETNAME

	arg0_7.instance:AsynUpdateLoad(var0_7, FOLDERNAME .. arg1_7, arg2_7, arg3_7)
end

function var0_0.DeleteObject(arg0_8, arg1_8, arg2_8)
	if not arg0_8.instance then
		arg2_8()

		return
	end

	local var0_8 = OSSBUCKETNAME

	arg0_8.instance:DeleteObject(var0_8, FOLDERNAME .. arg1_8, arg2_8)
end

function var0_0.GetSprite(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9)
	if not arg0_9.instance then
		arg6_9()

		return
	end

	local var0_9 = OSSBUCKETNAME

	arg0_9.instance:GetSprite(var0_9, FOLDERNAME .. arg1_9, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9)
end

function var0_0.GetTexture2D(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10, arg6_10)
	if not arg0_10.instance then
		arg6_10()

		return
	end

	local var0_10 = OSSBUCKETNAME

	arg0_10.instance:GetTexture(var0_10, FOLDERNAME .. arg1_10, arg2_10, arg3_10, arg4_10, arg5_10, arg6_10)
end

function var0_0.AddExpireTimer(arg0_11, arg1_11)
	arg0_11:RemoveExpireTimer()

	if not arg1_11 or arg1_11 == 0 then
		return
	end

	local var0_11 = arg1_11 - pg.TimeMgr.GetInstance():GetServerTime()

	if var0_11 <= 0 then
		var0_11 = 300
	end

	print("expireTime: ", var0_11)

	arg0_11.timer = Timer.New(function()
		arg0_11:InitClinet()
	end, var0_11, 1)

	arg0_11.timer:Start()
end

function var0_0.RemoveExpireTimer(arg0_13)
	if arg0_13.timer then
		arg0_13.timer:Stop()

		arg0_13.timer = nil
	end
end

function var0_0.Dispose(arg0_14)
	arg0_14:RemoveExpireTimer()
end

return var0_0
