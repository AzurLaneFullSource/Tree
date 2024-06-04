local var0 = class("AttireDescPanel")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.icon = findTF(arg0._tf, "icon")
	arg0.frame = findTF(arg0._tf, "frame")
	arg0.chatContainer = findTF(arg0._tf, "chatContainer")
	arg0.conditionTF = findTF(arg0._tf, "condition")
	arg0.nameTxt = findTF(arg0._tf, "name/Text"):GetComponent(typeof(Text))
	arg0.stateTxt = findTF(arg0._tf, "get_info/lock"):GetComponent(typeof(Text))
	arg0.timeTxt = findTF(arg0._tf, "get_info/time"):GetComponent(typeof(Text))
	arg0.conditionTxt = findTF(arg0._tf, "condition/Text"):GetComponent(typeof(Text))
	arg0.applyBtn = findTF(arg0._tf, "apply_btn")
	arg0.applyingBtn = findTF(arg0._tf, "applying_btn")
	arg0.getBtn = findTF(arg0._tf, "get_btn")
end

function var0.Update(arg0, arg1, arg2)
	arg0:UpdateIconDesc(arg1, arg2)

	arg0.nameTxt.text = HXSet.hxLan(arg1:getConfig("name"))

	local var0 = arg1:isOwned()
	local var1 = var0 and i18n("word_got") or i18n("word_not_get")

	arg0.stateTxt.text = setColorStr(var1, var0 and "#3DC6FFFF" or "#a5afdf")

	local var2 = arg1:expiredType()

	arg0:RemoveTimer()

	if var0 and var2 then
		arg0:AddTimer(arg1, arg2)
	elseif var0 and not var2 then
		arg0.timeTxt.text = ""
	elseif not var0 then
		arg0.timeTxt.text = ""
	end

	arg0.conditionTxt.text = HXSet.hxLan(arg1:getConfig("desc"))

	local var3 = arg1:getState()
	local var4 = arg2:getAttireByType(arg1:getType()) == arg1.id

	setActive(arg0.applyBtn, var3 == AttireFrame.STATE_UNLOCK and not var4)
	setActive(arg0.applyingBtn, var3 == AttireFrame.STATE_UNLOCK and var4)
	setActive(arg0.getBtn, var3 == AttireFrame.STATE_LOCK)
end

function var0.UpdateIconDesc(arg0, arg1, arg2)
	local var0 = arg1:getType() == AttireConst.TYPE_ICON_FRAME
	local var1 = arg1:getType() == AttireConst.TYPE_CHAT_FRAME

	if arg0.loadedIcon and arg0.loadedIconTF then
		local var2 = arg0.loadedIcon:getIcon()

		if var1 then
			arg0.loadedIconTF.transform:Find("Text"):GetComponent(typeof(Text)).supportRichText = false
		end

		PoolMgr.GetInstance():ReturnPrefab(var2, arg0.loadedIcon.id, arg0.loadedIconTF)
	end

	if var0 then
		if not arg0.startList then
			arg0.startList = UIItemList.New(findTF(arg0._tf, "stars"), findTF(arg0._tf, "stars/tpl"))
		end

		local var3 = arg1:getIcon()

		PoolMgr.GetInstance():GetPrefab(var3, arg1:getConfig("id"), true, function(arg0)
			arg0.loadedIcon = arg1
			arg0.loadedIconTF = arg0

			setParent(arg0, arg0.frame, false)
		end)

		local var4 = arg2:GetFlagShip()

		LoadSpriteAsync("qicon/" .. var4:getPrefab(), function(arg0)
			arg0.icon:GetComponent(typeof(Image)).sprite = arg0
		end)
		arg0.startList:align(var4:getStar())
	elseif var1 then
		local var5 = arg1:getIcon()

		PoolMgr.GetInstance():GetPrefab(var5, arg1:getConfig("id") .. "_self", true, function(arg0)
			arg0.loadedIcon = arg1
			arg0.loadedIconTF = arg0

			setParent(arg0, arg0.chatContainer, false)

			tf(arg0).localPosition = Vector3(0, 0, 0)
			findTF(arg0, "Text"):GetComponent(typeof(Text)).supportRichText = true

			setText(findTF(arg0, "Text"), arg1:getConfig("desc"))
		end)
	end

	setActive(arg0.conditionTF, not var1)
end

function var0.AddTimer(arg0, arg1, arg2)
	local var0 = arg1:getExpiredTime()

	arg0.timer = Timer.New(function()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1 = var0 - var0

		if var1 > 0 then
			arg0.timeTxt.text = "/ " .. attireTimeStamp(var1)
		else
			arg0:Update(arg1, arg2)
			arg0:RemoveTimer()
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:RemoveTimer()
end

return var0
