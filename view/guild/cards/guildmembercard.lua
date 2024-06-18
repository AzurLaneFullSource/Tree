local var0_0 = class("GuildMemberCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = tf(arg1_1)
	arg0_1.iconTF = arg0_1.tf:Find("shipicon/icon"):GetComponent(typeof(Image))
	arg0_1.starsTF = arg0_1.tf:Find("shipicon/stars")
	arg0_1.starTF = arg0_1.tf:Find("shipicon/stars/star")
	arg0_1.levelTF = arg0_1.tf:Find("level/Text"):GetComponent(typeof(Text))
	arg0_1.nameTF = arg0_1.tf:Find("name_bg/Text"):GetComponent(typeof(Text))
	arg0_1.dutyTF = arg0_1.tf:Find("duty"):GetComponent(typeof(Image))
	arg0_1.livenessTF = arg0_1.tf:Find("liveness/Text"):GetComponent(typeof(Text))
	arg0_1.onLine = arg0_1.tf:Find("online_tag")
	arg0_1.offLine = arg0_1.tf:Find("last_time")
	arg0_1.onLineLabel = arg0_1.tf:Find("online")
	arg0_1.offLineLabel = arg0_1.tf:Find("offline")
	arg0_1.offLineText = arg0_1.tf:Find("last_time/Text"):GetComponent(typeof(Text))
	arg0_1.maskTF = arg0_1.tf:Find("mask")
	arg0_1.timerTF = arg0_1.tf:Find("mask/Text"):GetComponent(typeof(Text))
	arg0_1.borderTF = arg0_1.tf:Find("selected")
	arg0_1.bg = arg0_1.tf:Find("bg")
	arg0_1.circle = arg0_1.tf:Find("shipicon/frame")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.memberVO = arg1_2

	arg0_2:Clear()

	local var0_2 = pg.ship_data_statistics[arg1_2.icon]
	local var1_2 = Ship.New({
		configId = arg1_2.icon,
		skin_id = arg1_2.skinId,
		propose = arg1_2.proposeTime
	})

	LoadSpriteAsync("qicon/" .. var1_2:getPainting(), function(arg0_3)
		if not IsNil(arg0_2.iconTF) then
			arg0_2.iconTF.sprite = arg0_3
		end
	end)

	local var2_2 = AttireFrame.attireFrameRes(arg1_2, arg1_2.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1_2.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2_2, var2_2, true, function(arg0_4)
		if arg0_2.circle and not arg0_2.exited then
			arg0_4.name = var2_2
			findTF(arg0_4.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_4, arg0_2.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_2, var2_2, arg0_4)
		end
	end)

	local var3_2 = GetSpriteFromAtlas("dutyicon", arg1_2.duty)

	arg0_2.dutyTF.sprite = var3_2

	local var4_2 = arg0_2.starsTF.childCount

	for iter0_2 = var4_2, var0_2.star - 1 do
		cloneTplTo(arg0_2.starTF, arg0_2.starsTF)
	end

	for iter1_2 = 1, var4_2 do
		local var5_2 = arg0_2.starsTF:GetChild(iter1_2 - 1)

		setActive(var5_2, iter1_2 <= var0_2.star)
	end

	arg0_2.levelTF.text = arg1_2.level
	arg0_2.nameTF.text = arg1_2.name
	arg0_2.livenessTF.text = arg1_2.liveness

	setActive(arg0_2.onLine, arg1_2:isOnline())
	setActive(arg0_2.offLine, not arg1_2:isOnline())
	setActive(arg0_2.onLineLabel, arg1_2:isOnline())
	setActive(arg0_2.offLineLabel, not arg1_2:isOnline())

	if not arg1_2:isOnline() then
		arg0_2.offLineText.text = getOfflineTimeStamp(arg1_2.preOnLineTime)
	end

	local var6_2 = arg1_2.duty == GuildConst.DUTY_COMMANDER and arg2_2:inKickTime()

	setActive(arg0_2.maskTF, var6_2)

	if var6_2 then
		arg0_2:AddTimer(function()
			local var0_5 = arg2_2:getKickLeftTime()

			if var0_5 > 0 then
				arg0_2.timerTF.text = pg.TimeMgr.GetInstance():DescCDTime(var0_5)
			else
				arg0_2.timerTF.text = ""

				setActive(arg0_2.maskTF, false)
			end
		end)
	end
end

function var0_0.AddTimer(arg0_6, arg1_6)
	if arg0_6.timer then
		arg0_6.timer:Stop()

		arg0_6.timer = nil
	end

	arg0_6.timer = Timer.New(arg1_6, 1, -1)

	arg0_6.timer:Start()
	arg0_6.timer.func()
end

function var0_0.Clear(arg0_7)
	if arg0_7.circle.childCount > 0 then
		local var0_7 = arg0_7.circle:GetChild(0)
		local var1_7 = var0_7.gameObject.name

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1_7, var1_7, var0_7.gameObject)
	end

	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.SetSelected(arg0_8, arg1_8)
	setActive(arg0_8.borderTF, arg1_8)
	setActive(arg0_8.bg, not arg1_8)
end

function var0_0.Dispose(arg0_9)
	arg0_9.exited = true

	arg0_9:Clear()
end

return var0_0
