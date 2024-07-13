ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = class("BattleDropsView")

var0_0.Battle.BattleDropsView = var2_0
var2_0.__name = "BattleDropsView"
var2_0.FLOAT_DURATION = 0.4

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._container = arg2_1
	arg0_1._containerTF = arg0_1._container.transform

	arg0_1:init()
end

function var2_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._go, arg1_2)
end

function var2_0.AddCamera(arg0_3, arg1_3, arg2_3)
	arg0_3._camera = arg1_3
	arg0_3._uiCamera = arg2_3
	arg0_3._cameraTF = arg0_3._camera.transform

	local var0_3 = arg0_3._cameraTF.localPosition

	arg0_3._cameraSrcX = var0_3.x
	arg0_3._cameraSrcZ = var0_3.z
	arg0_3._cameraXRotate = arg0_3._cameraTF.localEulerAngles.x
end

function var2_0.RefreshScaleRate(arg0_4)
	local var0_4 = UnityEngine.Screen.width
	local var1_4 = UnityEngine.Screen.height
	local var2_4 = arg0_4._camera:ScreenToWorldPoint(Vector3(var0_4, var1_4, 0))

	arg0_4._xScale = var0_4 / var2_4.x
	arg0_4._yScale = var1_4 / var2_4.y
end

function var2_0.Update(arg0_5)
	if #arg0_5._resourceList == #arg0_5._resourcePool then
		return
	end

	arg0_5:updateContainerPosition()
end

function var2_0.init(arg0_6)
	arg0_6._resourceIcon = arg0_6._tf:Find("resourceIcon")
	arg0_6._resourceText = arg0_6._tf:Find("resourceText"):GetComponent(typeof(Text))
	arg0_6._resourceGO = arg0_6._containerTF:Find("spin_gold")

	local var0_6 = arg0_6._tf.rect.width / 2
	local var1_6 = arg0_6._tf.rect.height / 2

	arg0_6._resourceIconX = arg0_6._resourceIcon.transform.anchoredPosition.x + var0_6
	arg0_6._resourceIconY = arg0_6._resourceIcon.transform.anchoredPosition.y + var1_6
	arg0_6._itemPool = {}
	arg0_6._resourcePool = {}
	arg0_6._resourceList = {}
	arg0_6._itemCount = 0
	arg0_6._resourceCount = 0

	arg0_6:updateCountText(arg0_6._resourceText)

	arg0_6._timerList = {}

	local var2_6 = {}

	for iter0_6 = 1, 5 do
		table.insert(var2_6, arg0_6:pop(arg0_6._resourcePool))
	end

	for iter1_6 = 1, 5 do
		arg0_6:push(var2_6[iter1_6], arg0_6._resourcePool)
	end

	local var3_6
end

function var2_0.pop(arg0_7, arg1_7)
	local var0_7

	if #arg1_7 == 0 then
		if arg1_7 == arg0_7._resourcePool then
			var0_7 = Object.Instantiate(arg0_7._resourceGO, Vector3.zero, Quaternion.identity)
			arg0_7._resourceList[#arg0_7._resourceList + 1] = var0_7
		end

		var0_7.transform:SetParent(arg0_7._go, false)
	else
		var0_7 = arg1_7[#arg1_7]
		arg1_7[#arg1_7] = nil
	end

	return var0_7
end

function var2_0.push(arg0_8, arg1_8, arg2_8)
	arg1_8.transform.localScale = Vector3(0.35, 0.35, 0.35)
	arg1_8:GetComponent(typeof(Animator)).enabled = false

	SetActive(arg1_8, false)

	arg2_8[#arg2_8 + 1] = arg1_8
end

function var2_0.updateCountText(arg0_9, arg1_9)
	local var0_9

	if arg1_9 == arg0_9._resourceText then
		var0_9 = arg0_9._resourceCount
	end

	if var0_9 > 999 then
		arg1_9.text = string.format("%s%.1f%s", "x", var0_9 / 1000, "k")
	else
		arg1_9.text = string.format("%s%d", "x", var0_9)
	end
end

function var2_0.ShowDrop(arg0_10, arg1_10)
	if #arg0_10._resourceList == #arg0_10._resourcePool then
		arg0_10:updateContainerPosition()
	end

	local var0_10 = var0_0.Battle.BattleVariable.CameraPosToUICamera(arg1_10.scenePos:Clone())
	local var1_10 = Vector3(var0_10.x, var0_10.y, 2)
	local var2_10 = arg1_10.drops.resourceCount
	local var3_10, var4_10 = math.modf(var2_10 / var1_0.RESOURCE_STEP)

	if var4_10 > 0 then
		arg0_10:makeFloatAnima(var1_10, arg0_10._resourcePool, arg0_10._resourceIconX, arg0_10._resourceIconY, arg0_10._resourceIcon, "_resourceCount", var4_10 * var1_0.RESOURCE_STEP, arg0_10._resourceText, 0)
	end

	while var3_10 > 0 do
		arg0_10:makeFloatAnima(var1_10, arg0_10._resourcePool, arg0_10._resourceIconX, arg0_10._resourceIconY, arg0_10._resourceIcon, "_resourceCount", var1_0.RESOURCE_STEP, arg0_10._resourceText, var3_10)

		var3_10 = var3_10 - 1
	end
end

function var2_0.updateContainerPosition(arg0_11)
	local var0_11 = arg0_11._cameraTF.localPosition

	arg0_11._containerTF.localPosition = Vector3(arg0_11._xScale * (arg0_11._cameraSrcX - var0_11.x), arg0_11._yScale * (arg0_11._cameraSrcZ - var0_11.z), 0)
end

function var2_0.makeFloatAnima(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12, arg5_12, arg6_12, arg7_12, arg8_12, arg9_12)
	local var0_12 = arg0_12:pop(arg2_12)
	local var1_12 = var0_12.transform

	SetActive(var0_12, true)

	var1_12.position = arg1_12
	var1_12.localPosition = var1_12.localPosition - arg0_12._containerTF.localPosition

	arg0_12:Update()
	var1_12:SetParent(arg0_12._container, false)

	local var2_12 = math.random() * 200 - 100
	local var3_12 = math.random() * 200

	LeanTween.moveX(rtf(var0_12), var1_12.anchoredPosition.x + var2_12, var1_0.RESOURCE_STAY_DURATION + arg9_12 * 0.05):setOnComplete(System.Action(function()
		LeanTween.scale(go(var0_12), Vector3(0.2, 0.2, 1), var2_0.FLOAT_DURATION)

		local var0_13 = Vector3(arg3_12 - var1_12.position.x, arg4_12 - var1_12.position.y, 0)

		var1_12.localPosition = var1_12.localPosition + arg0_12._containerTF.localPosition

		var1_12:SetParent(arg0_12._go, false)
		LeanTween.move(rtf(var0_12), var0_13, var2_0.FLOAT_DURATION):setOnComplete(System.Action(function()
			arg0_12:push(var0_12, arg2_12)

			arg5_12.transform.localScale = Vector3(0.35, 0.35, 0.35)
			arg0_12[arg6_12] = arg0_12[arg6_12] + arg7_12

			arg0_12:updateCountText(arg8_12)
			LeanTween.scale(go(arg5_12), Vector3(0.5, 0.5, 0.5), 0.12):setEase(LeanTweenType.easeOutExpo):setOnComplete(System.Action(function()
				LeanTween.scale(go(arg5_12), Vector3(0.35, 0.35, 0.35), 0.3)
			end))
		end))
	end))

	local var4_12 = var3_12 / 200

	LeanTween.moveY(rtf(var0_12), var1_12.anchoredPosition.y + var3_12, 0.5 * var4_12):setOnComplete(System.Action(function()
		var0_12:GetComponent("Animator").enabled = true

		LeanTween.moveY(rtf(var0_12), var1_12.anchoredPosition.y - var3_12, 1.5 * var4_12):setEase(LeanTweenType.easeOutBounce)
	end))
end

function var2_0.Dispose(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17._timerList) do
		if iter1_17 then
			pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0_17)
		end
	end

	for iter2_17, iter3_17 in ipairs(arg0_17._resourceList) do
		LeanTween.cancel(go(iter3_17))
	end

	arg0_17._timerList = nil
	arg0_17._go = nil
	arg0_17._resourceIcon = nil
	arg0_17._resourceText = nil
	arg0_17._itemIcon = nil
	arg0_17._itemText = nil
	arg0_17._camera = nil
	arg0_17._uiCamera = nil
end
