ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = class("BattleDropsView")

var0.Battle.BattleDropsView = var2
var2.__name = "BattleDropsView"
var2.FLOAT_DURATION = 0.4

function var2.Ctor(arg0, arg1, arg2)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._container = arg2
	arg0._containerTF = arg0._container.transform

	arg0:init()
end

function var2.SetActive(arg0, arg1)
	setActive(arg0._go, arg1)
end

function var2.AddCamera(arg0, arg1, arg2)
	arg0._camera = arg1
	arg0._uiCamera = arg2
	arg0._cameraTF = arg0._camera.transform

	local var0 = arg0._cameraTF.localPosition

	arg0._cameraSrcX = var0.x
	arg0._cameraSrcZ = var0.z
	arg0._cameraXRotate = arg0._cameraTF.localEulerAngles.x
end

function var2.RefreshScaleRate(arg0)
	local var0 = UnityEngine.Screen.width
	local var1 = UnityEngine.Screen.height
	local var2 = arg0._camera:ScreenToWorldPoint(Vector3(var0, var1, 0))

	arg0._xScale = var0 / var2.x
	arg0._yScale = var1 / var2.y
end

function var2.Update(arg0)
	if #arg0._resourceList == #arg0._resourcePool then
		return
	end

	arg0:updateContainerPosition()
end

function var2.init(arg0)
	arg0._resourceIcon = arg0._tf:Find("resourceIcon")
	arg0._resourceText = arg0._tf:Find("resourceText"):GetComponent(typeof(Text))
	arg0._resourceGO = arg0._containerTF:Find("spin_gold")

	local var0 = arg0._tf.rect.width / 2
	local var1 = arg0._tf.rect.height / 2

	arg0._resourceIconX = arg0._resourceIcon.transform.anchoredPosition.x + var0
	arg0._resourceIconY = arg0._resourceIcon.transform.anchoredPosition.y + var1
	arg0._itemPool = {}
	arg0._resourcePool = {}
	arg0._resourceList = {}
	arg0._itemCount = 0
	arg0._resourceCount = 0

	arg0:updateCountText(arg0._resourceText)

	arg0._timerList = {}

	local var2 = {}

	for iter0 = 1, 5 do
		table.insert(var2, arg0:pop(arg0._resourcePool))
	end

	for iter1 = 1, 5 do
		arg0:push(var2[iter1], arg0._resourcePool)
	end

	local var3
end

function var2.pop(arg0, arg1)
	local var0

	if #arg1 == 0 then
		if arg1 == arg0._resourcePool then
			var0 = Object.Instantiate(arg0._resourceGO, Vector3.zero, Quaternion.identity)
			arg0._resourceList[#arg0._resourceList + 1] = var0
		end

		var0.transform:SetParent(arg0._go, false)
	else
		var0 = arg1[#arg1]
		arg1[#arg1] = nil
	end

	return var0
end

function var2.push(arg0, arg1, arg2)
	arg1.transform.localScale = Vector3(0.35, 0.35, 0.35)
	arg1:GetComponent(typeof(Animator)).enabled = false

	SetActive(arg1, false)

	arg2[#arg2 + 1] = arg1
end

function var2.updateCountText(arg0, arg1)
	local var0

	if arg1 == arg0._resourceText then
		var0 = arg0._resourceCount
	end

	if var0 > 999 then
		arg1.text = string.format("%s%.1f%s", "x", var0 / 1000, "k")
	else
		arg1.text = string.format("%s%d", "x", var0)
	end
end

function var2.ShowDrop(arg0, arg1)
	if #arg0._resourceList == #arg0._resourcePool then
		arg0:updateContainerPosition()
	end

	local var0 = var0.Battle.BattleVariable.CameraPosToUICamera(arg1.scenePos:Clone())
	local var1 = Vector3(var0.x, var0.y, 2)
	local var2 = arg1.drops.resourceCount
	local var3, var4 = math.modf(var2 / var1.RESOURCE_STEP)

	if var4 > 0 then
		arg0:makeFloatAnima(var1, arg0._resourcePool, arg0._resourceIconX, arg0._resourceIconY, arg0._resourceIcon, "_resourceCount", var4 * var1.RESOURCE_STEP, arg0._resourceText, 0)
	end

	while var3 > 0 do
		arg0:makeFloatAnima(var1, arg0._resourcePool, arg0._resourceIconX, arg0._resourceIconY, arg0._resourceIcon, "_resourceCount", var1.RESOURCE_STEP, arg0._resourceText, var3)

		var3 = var3 - 1
	end
end

function var2.updateContainerPosition(arg0)
	local var0 = arg0._cameraTF.localPosition

	arg0._containerTF.localPosition = Vector3(arg0._xScale * (arg0._cameraSrcX - var0.x), arg0._yScale * (arg0._cameraSrcZ - var0.z), 0)
end

function var2.makeFloatAnima(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	local var0 = arg0:pop(arg2)
	local var1 = var0.transform

	SetActive(var0, true)

	var1.position = arg1
	var1.localPosition = var1.localPosition - arg0._containerTF.localPosition

	arg0:Update()
	var1:SetParent(arg0._container, false)

	local var2 = math.random() * 200 - 100
	local var3 = math.random() * 200

	LeanTween.moveX(rtf(var0), var1.anchoredPosition.x + var2, var1.RESOURCE_STAY_DURATION + arg9 * 0.05):setOnComplete(System.Action(function()
		LeanTween.scale(go(var0), Vector3(0.2, 0.2, 1), var2.FLOAT_DURATION)

		local var0 = Vector3(arg3 - var1.position.x, arg4 - var1.position.y, 0)

		var1.localPosition = var1.localPosition + arg0._containerTF.localPosition

		var1:SetParent(arg0._go, false)
		LeanTween.move(rtf(var0), var0, var2.FLOAT_DURATION):setOnComplete(System.Action(function()
			arg0:push(var0, arg2)

			arg5.transform.localScale = Vector3(0.35, 0.35, 0.35)
			arg0[arg6] = arg0[arg6] + arg7

			arg0:updateCountText(arg8)
			LeanTween.scale(go(arg5), Vector3(0.5, 0.5, 0.5), 0.12):setEase(LeanTweenType.easeOutExpo):setOnComplete(System.Action(function()
				LeanTween.scale(go(arg5), Vector3(0.35, 0.35, 0.35), 0.3)
			end))
		end))
	end))

	local var4 = var3 / 200

	LeanTween.moveY(rtf(var0), var1.anchoredPosition.y + var3, 0.5 * var4):setOnComplete(System.Action(function()
		var0:GetComponent("Animator").enabled = true

		LeanTween.moveY(rtf(var0), var1.anchoredPosition.y - var3, 1.5 * var4):setEase(LeanTweenType.easeOutBounce)
	end))
end

function var2.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._timerList) do
		if iter1 then
			pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0)
		end
	end

	for iter2, iter3 in ipairs(arg0._resourceList) do
		LeanTween.cancel(go(iter3))
	end

	arg0._timerList = nil
	arg0._go = nil
	arg0._resourceIcon = nil
	arg0._resourceText = nil
	arg0._itemIcon = nil
	arg0._itemText = nil
	arg0._camera = nil
	arg0._uiCamera = nil
end
