local var0 = class("GuildMemberCard")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tf = tf(arg1)
	arg0.iconTF = arg0.tf:Find("shipicon/icon"):GetComponent(typeof(Image))
	arg0.starsTF = arg0.tf:Find("shipicon/stars")
	arg0.starTF = arg0.tf:Find("shipicon/stars/star")
	arg0.levelTF = arg0.tf:Find("level/Text"):GetComponent(typeof(Text))
	arg0.nameTF = arg0.tf:Find("name_bg/Text"):GetComponent(typeof(Text))
	arg0.dutyTF = arg0.tf:Find("duty"):GetComponent(typeof(Image))
	arg0.livenessTF = arg0.tf:Find("liveness/Text"):GetComponent(typeof(Text))
	arg0.onLine = arg0.tf:Find("online_tag")
	arg0.offLine = arg0.tf:Find("last_time")
	arg0.onLineLabel = arg0.tf:Find("online")
	arg0.offLineLabel = arg0.tf:Find("offline")
	arg0.offLineText = arg0.tf:Find("last_time/Text"):GetComponent(typeof(Text))
	arg0.maskTF = arg0.tf:Find("mask")
	arg0.timerTF = arg0.tf:Find("mask/Text"):GetComponent(typeof(Text))
	arg0.borderTF = arg0.tf:Find("selected")
	arg0.bg = arg0.tf:Find("bg")
	arg0.circle = arg0.tf:Find("shipicon/frame")
end

function var0.Update(arg0, arg1, arg2)
	arg0.memberVO = arg1

	arg0:Clear()

	local var0 = pg.ship_data_statistics[arg1.icon]
	local var1 = Ship.New({
		configId = arg1.icon,
		skin_id = arg1.skinId,
		propose = arg1.proposeTime
	})

	LoadSpriteAsync("qicon/" .. var1:getPainting(), function(arg0)
		if not IsNil(arg0.iconTF) then
			arg0.iconTF.sprite = arg0
		end
	end)

	local var2 = AttireFrame.attireFrameRes(arg1, arg1.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2, var2, true, function(arg0)
		if arg0.circle and not arg0.exited then
			arg0.name = var2
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2, var2, arg0)
		end
	end)

	local var3 = GetSpriteFromAtlas("dutyicon", arg1.duty)

	arg0.dutyTF.sprite = var3

	local var4 = arg0.starsTF.childCount

	for iter0 = var4, var0.star - 1 do
		cloneTplTo(arg0.starTF, arg0.starsTF)
	end

	for iter1 = 1, var4 do
		local var5 = arg0.starsTF:GetChild(iter1 - 1)

		setActive(var5, iter1 <= var0.star)
	end

	arg0.levelTF.text = arg1.level
	arg0.nameTF.text = arg1.name
	arg0.livenessTF.text = arg1.liveness

	setActive(arg0.onLine, arg1:isOnline())
	setActive(arg0.offLine, not arg1:isOnline())
	setActive(arg0.onLineLabel, arg1:isOnline())
	setActive(arg0.offLineLabel, not arg1:isOnline())

	if not arg1:isOnline() then
		arg0.offLineText.text = getOfflineTimeStamp(arg1.preOnLineTime)
	end

	local var6 = arg1.duty == GuildConst.DUTY_COMMANDER and arg2:inKickTime()

	setActive(arg0.maskTF, var6)

	if var6 then
		arg0:AddTimer(function()
			local var0 = arg2:getKickLeftTime()

			if var0 > 0 then
				arg0.timerTF.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
			else
				arg0.timerTF.text = ""

				setActive(arg0.maskTF, false)
			end
		end)
	end
end

function var0.AddTimer(arg0, arg1)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.timer = Timer.New(arg1, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.Clear(arg0)
	if arg0.circle.childCount > 0 then
		local var0 = arg0.circle:GetChild(0)
		local var1 = var0.gameObject.name

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1, var1, var0.gameObject)
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.SetSelected(arg0, arg1)
	setActive(arg0.borderTF, arg1)
	setActive(arg0.bg, not arg1)
end

function var0.Dispose(arg0)
	arg0.exited = true

	arg0:Clear()
end

return var0
