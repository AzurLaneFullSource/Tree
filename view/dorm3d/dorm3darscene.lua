local var0_0 = class("Dorm3dARScene", import("view.base.BaseUI"))
local var1_0 = "dorm3d/scenesres/scenes/arscene/arscene_scene"

function var0_0.getUIName(arg0_1)
	return "Dorm3DARUI"
end

function var0_0.preload(arg0_2, arg1_2)
	arg0_2.sceneName = "ARScene"

	seriesAsync({
		function(arg0_3)
			pg.UIMgr.GetInstance():LoadingOn(false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower(var1_0), arg0_2.sceneName, LoadSceneMode.Additive, function(arg0_4, arg1_4)
				arg0_3()
			end)
		end,
		function(arg0_5)
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_5()
		end,
		arg1_2
	})
end

function var0_0.init(arg0_6)
	arg0_6:findUI()
	arg0_6:addListener()
end

function var0_0.didEnter(arg0_7)
	return
end

function var0_0.willExit(arg0_8)
	SceneOpMgr.Inst:UnloadSceneAsync(string.lower(var1_0), arg0_8.sceneName)
end

function var0_0.findUI(arg0_9)
	arg0_9.backBtn = arg0_9:findTF("BackBtn")

	local var0_9 = arg0_9:findTF("MenuList")

	arg0_9.resetBtn = arg0_9:findTF("ResetBtn", var0_9)
	arg0_9.showPlaneBtn = arg0_9:findTF("ShowPlaneBtn", var0_9)
	arg0_9.hidePlaneBtn = arg0_9:findTF("HidePlaneBtn", var0_9)

	local var1_9 = arg0_9:findTF("TipText")

	arg0_9.tipCheckPlane = arg0_9:findTF("CheckPlaneText", var1_9)
	arg0_9.tipInsPrefab = arg0_9:findTF("InsPrefabText", var1_9)
	arg0_9.tipDistance = arg0_9:findTF("DistanceText", var1_9)

	setText(arg0_9.tipCheckPlane, "请检测一个平面")
	setText(arg0_9.tipInsPrefab, "长按平面呼出角色")
	setText(arg0_9.tipDistance, "距离太近隐藏角色")
	setActive(arg0_9.tipCheckPlane, false)
	setActive(arg0_9.tipInsPrefab, false)
	setActive(arg0_9.tipDistance, false)

	local var2_9 = GameObject.Find("ScriptHander")

	arg0_9.aiHelperSC = GetComponent(var2_9, "ARHelper")
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:closeView()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.resetBtn, function()
		arg0_10.aiHelperSC:ResetAll()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.showPlaneBtn, function()
		arg0_10.aiHelperSC:ShowAllPlane(true)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.hidePlaneBtn, function()
		arg0_10.aiHelperSC:ShowAllPlane(false)
	end, SFX_PANEL)

	function arg0_10.aiHelperSC.planeCountCB(arg0_15, arg1_15)
		local var0_15 = arg0_15 > 0

		setActive(arg0_10.tipCheckPlane, not var0_15)
		setActive(arg0_10.tipInsPrefab, var0_15 and not arg1_15)
	end

	function arg0_10.aiHelperSC.distanceCB(arg0_16)
		pg.TipsMgr.GetInstance():ShowTips("距离过近，以后会隐藏")
	end

	function arg0_10.aiHelperSC.insPrefabFailCB()
		pg.TipsMgr.GetInstance():ShowTips("距离过近，呼出角色失败")
	end

	function arg0_10.aiHelperSC.insPrefabSuccCB()
		pg.TipsMgr.GetInstance():ShowTips("呼出角色成功")
		arg0_10.aiHelperSC:StopPlaneCheck()
	end
end

return var0_0
