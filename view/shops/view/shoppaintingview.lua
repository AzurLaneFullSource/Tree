local var0 = class("ShopPaintingView")

function var0.Ctor(arg0, arg1, arg2)
	arg0._painting = arg1
	arg0._paintingInitPos = arg0._painting.anchoredPosition
	arg0._paintingOffsetMin = Vector2(arg0._painting.offsetMin.x, arg0._painting.offsetMin.y)
	arg0._paintingOffsetMax = Vector2(arg0._painting.offsetMax.x, arg0._painting.offsetMax.y)
	arg0.touch = arg0._painting:Find("paint_touch")
	arg0.chat = arg2
	arg0.chatText = arg0.chat:Find("Text")
	arg0.name = nil
	arg0.chatting = false
	arg0.chatTrOffset = Vector3(118, -276, 0)
end

function var0.InitChatPosition(arg0)
	local var0 = arg0._painting.localPosition + arg0.chatTrOffset
	local var1 = arg0._painting.parent:TransformPoint(var0)
	local var2 = arg0.chat.parent:InverseTransformPoint(var1)

	arg0.chat.localPosition = Vector3(var2.x, var2.y, 0)
end

function var0.Init(arg0, arg1, arg2, arg3, arg4)
	if not arg0.isInitChatPosition then
		arg0.isInitChatPosition = true

		arg0:InitChatPosition()
	end

	arg0:UnLoad()

	arg0.name = arg1

	if arg2 and arg0.secretaryTf then
		arg0._painting.anchoredPosition = arg0.secretaryTf.anchoredPosition
		arg0._painting.offsetMin = arg0.secretaryTf.offsetMin
		arg0._painting.offsetMax = arg0.secretaryTf.offsetMax
	else
		arg0._painting.anchoredPosition = arg0._paintingInitPos
		arg0._painting.offsetMin = arg0._paintingOffsetMin
		arg0._painting.offsetMax = arg0._paintingOffsetMax
	end

	arg0:Load(arg3, arg4)
end

function var0.Load(arg0, arg1, arg2)
	local var0

	if arg0.name == "mingshi_live2d" then
		var0 = ShopMingShiPainting.New(arg0._painting)
	else
		var0 = ShopMeshPainting.New(arg0._painting)
	end

	arg0.iShopPainting = var0

	var0:Load(arg0.name, arg1, arg2)
end

function var0.setSecretaryPos(arg0, arg1)
	if arg1 then
		arg0.secretaryTf = arg1
	end
end

function var0.Chat(arg0, arg1, arg2, arg3, arg4)
	local var0 = 1

	if type(arg1) == "table" then
		var0 = math.random(1, #arg1)
		arg1 = arg1[var0]
	end

	if type(arg2) == "table" then
		arg2 = arg2[var0]
	end

	if type(arg3) == "table" then
		arg3 = arg3[var0]
	end

	local function var1()
		if arg1 then
			arg0:ShowShipWord(arg1)
		end

		if arg3 and arg0.iShopPainting then
			arg0.iShopPainting:Action(arg3)
		end
	end

	if not arg0.chatting or arg4 then
		arg0:StopChat()

		if arg2 then
			arg0:PlayCV(arg2, function(arg0)
				if arg0 then
					arg0._cueInfo = arg0.cueInfo
				end

				var1()
			end)
		else
			var1()
		end
	end
end

function var0.ShowShipWord(arg0, arg1)
	arg0.chatting = true

	if LeanTween.isTweening(go(arg0.chat)) then
		LeanTween.cancel(go(arg0.chat))
	end

	local var0 = 0.3
	local var1 = 3

	if arg0._cueInfo then
		local var2 = long2int(arg0._cueInfo.length) / 1000

		if var1 < var2 then
			var1 = var2
		end
	end

	setActive(arg0.chat, true)
	setText(arg0.chatText, arg1)
	LeanTween.scale(arg0.chat.gameObject, Vector3.New(1, 1, 1), var0):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		if IsNil(arg0.chat) then
			return
		end

		LeanTween.scale(arg0.chat.gameObject, Vector3.New(0, 0, 1), var0):setFrom(Vector3.New(1, 1, 1)):setEase(LeanTweenType.easeInBack):setDelay(var1):setOnComplete(System.Action(function()
			if IsNil(arg0.chat) then
				return
			end

			arg0:StopChat()
		end))
	end))
end

function var0.StopChat(arg0)
	arg0.chatting = nil

	if LeanTween.isTweening(go(arg0.chat)) then
		LeanTween.cancel(go(arg0.chat))
	end

	setActive(arg0.chat, false)
	arg0:StopCV()
end

local function var1(arg0, arg1)
	local var0
	local var1

	if string.find(arg1, "/") then
		local var2 = string.split(arg1, "/")

		var0 = var2[1]
		var1 = var2[2]
	elseif arg0.name == "mingshi_live2d" then
		var0 = "cv-chargeShop"
		var1 = arg1
	elseif string.find(arg1, "ryza_shop") then
		var0 = "cv-1090002"
		var1 = arg1
	else
		var0 = "cv-shop"
		var1 = arg1
	end

	return var0, var1
end

function var0.PlayCV(arg0, arg1, arg2)
	local var0, var1 = var1(arg0, arg1)

	arg0:StopCV()
	pg.CriMgr.GetInstance():PlayCV_V3(var0, var1, arg2)

	arg0._currentVoice = var0
end

function var0.StopCV(arg0)
	if arg0._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0._currentVoice)
	end

	arg0._currentVoice = nil
	arg0._cueInfo = nil
end

function var0.UnLoad(arg0)
	if arg0.iShopPainting and arg0.name then
		arg0.iShopPainting:UnLoad(arg0.name)

		arg0.name = nil
		arg0.iShopPainting = nil
	end
end

function var0.Dispose(arg0)
	arg0:UnLoad()
	arg0:StopCV()
end

return var0
