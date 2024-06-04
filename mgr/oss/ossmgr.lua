pg = pg or {}
pg.OSSMgr = singletonClass("OSSMgr")

local var0 = pg.OSSMgr

function var0.Ctor(arg0)
	if PLATFORM_CODE == PLATFORM_CH then
		arg0.instance = OSSStarter.ins
	end

	arg0.isIninted = false

	if arg0.instance then
		ReflectionHelp.RefSetField(typeof("OSSStarter"), "debug", arg0.instance, false)
	end
end

function var0.InitConfig(arg0)
	if PLATFORM_CODE == PLATFORM_CH then
		OSS_STS_URL = ""
		OSS_ENDPOINT = "oss-cn-hangzhou.aliyuncs.com"
		OSSBUCKETNAME = "blhx-dorm-oss"

		local var0 = pg.SdkMgr.GetInstance():GetChannelUID()
		local var1 = var0 == "cps" or var0 == "yun" or var0 == "0"

		if getProxy(UserProxy):GetCacheGatewayInServerLogined() == PLATFORM_IPHONEPLAYER then
			FOLDERNAME = "dorm_ios/"
		elseif var1 then
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

function var0.Init(arg0)
	arg0:InitConfig()

	if not arg0.isIninted then
		arg0.isIninted = true

		arg0:InitClinet()
	end
end

function var0.InitClinet(arg0, arg1)
	if not arg0.instance then
		return
	end

	local var0 = arg0.instance.initMode

	local function var1(arg0, arg1)
		arg0:AddExpireTimer(arg1)
		arg0.instance:InitWithArgs(unpack(arg0))
	end

	pg.m02:sendNotification(GAME.GET_OSS_ARGS, {
		mode = var0,
		callback = var1
	})
end

function var0.UpdateLoad(arg0, arg1, arg2, arg3)
	if not arg0.instance then
		arg3()

		return
	end

	local var0 = OSSBUCKETNAME

	arg0.instance:UpdateLoad(var0, FOLDERNAME .. arg1, arg2, arg3)
end

function var0.AsynUpdateLoad(arg0, arg1, arg2, arg3)
	if not arg0.instance then
		arg3()

		return
	end

	local var0 = OSSBUCKETNAME

	arg0.instance:AsynUpdateLoad(var0, FOLDERNAME .. arg1, arg2, arg3)
end

function var0.DeleteObject(arg0, arg1, arg2)
	if not arg0.instance then
		arg2()

		return
	end

	local var0 = OSSBUCKETNAME

	arg0.instance:DeleteObject(var0, FOLDERNAME .. arg1, arg2)
end

function var0.GetSprite(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	if not arg0.instance then
		arg6()

		return
	end

	local var0 = OSSBUCKETNAME

	arg0.instance:GetSprite(var0, FOLDERNAME .. arg1, arg2, arg3, arg4, arg5, arg6)
end

function var0.GetTexture2D(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	if not arg0.instance then
		arg6()

		return
	end

	local var0 = OSSBUCKETNAME

	arg0.instance:GetTexture(var0, FOLDERNAME .. arg1, arg2, arg3, arg4, arg5, arg6)
end

function var0.AddExpireTimer(arg0, arg1)
	arg0:RemoveExpireTimer()

	if not arg1 or arg1 == 0 then
		return
	end

	local var0 = arg1 - pg.TimeMgr.GetInstance():GetServerTime()

	if var0 <= 0 then
		var0 = 300
	end

	print("expireTime: ", var0)

	arg0.timer = Timer.New(function()
		arg0:InitClinet()
	end, var0, 1)

	arg0.timer:Start()
end

function var0.RemoveExpireTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:RemoveExpireTimer()
end

return var0
