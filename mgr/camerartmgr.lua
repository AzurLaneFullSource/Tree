pg = pg or {}
pg.CameraRTMgr = singletonClass("CameraRTMgr")

local var0_0 = pg.CameraRTMgr

var0_0.CONFIG = {
	posX = -500,
	height = 500,
	autoResize = false,
	camera = "TestCamera",
	posY = 200,
	rotY = 0,
	rotX = 0,
	rotZ = 0,
	id = 1,
	width = 500
}

function var0_0.Init(arg0_1, arg1_1)
	print("initializing camera rt manager...")

	arg0_1.mainTransform = pg.UIMgr.GetInstance().UIMain.transform
	arg0_1.uiList = {}

	arg1_1()
end

function var0_0.Bind(arg0_2, arg1_2, arg2_2)
	assert(arg1_2 and arg2_2)

	arg1_2.RenderCamera = arg2_2

	setActive(arg2_2, true)
end

function var0_0.Clean(arg0_3, arg1_3)
	assert(arg1_3)
	arg1_3:CleanRenderTexture()
	setActive(arg1_3.RenderCamera, false)

	arg1_3.RenderCamera = nil
end

function var0_0.Create(arg0_4, arg1_4)
	local var0_4 = GameObject.Find("[RTCamera]")

	assert(var0_4, "不存在[RTCamera]")

	local var1_4 = findTF(var0_4, arg1_4.camera)

	assert(var1_4, "不存在相机" .. arg1_4.camera)

	local var2_4 = "CameraRTUI" .. arg1_4.id
	local var3_4 = GameObject(var2_4)
	local var4_4 = GetOrAddComponent(var3_4, "CameraRTUI")

	setActive(var1_4, true)
	setParent(var3_4, arg0_4.mainTransform, false)
	setSizeDelta(var3_4, {
		x = arg1_4.width,
		y = arg1_4.height
	})
	setLocalEulerAngles(var3_4, {
		x = arg1_4.rotX,
		y = arg1_4.rotY,
		z = arg1_4.rotZ
	})
	setAnchoredPosition(var3_4, {
		x = arg1_4.posX,
		y = arg1_4.posY
	})

	var4_4.autoResize = arg1_4.autoResize
	var4_4.RenderCamera = var1_4:GetComponent(typeof(Camera))
	arg0_4.uiList[var2_4] = var3_4

	return var3_4
end

function var0_0.ShowOrHide(arg0_5, arg1_5, arg2_5)
	local var0_5 = "CameraRTUI" .. arg1_5
	local var1_5 = arg0_5.uiList[var0_5]

	if not var1_5 then
		warning("不存在CameraRTUI id=" .. arg1_5)

		return
	end

	setActive(var1_5:GetComponent("CameraRTUI").RenderCamera, arg2_5)
	setActive(var1_5, arg2_5)
end

function var0_0.Destroy(arg0_6, arg1_6)
	local var0_6 = "CameraRTUI" .. arg1_6
	local var1_6 = arg0_6.uiList[var0_6]

	if not var1_6 then
		warning("不存在CameraRTUI id=" .. arg1_6)

		return
	end

	setActive(var1_6:GetComponent("CameraRTUI").RenderCamera, false)
	Destroy(var1_6)

	arg0_6.uiList[var0_6] = nil
end
