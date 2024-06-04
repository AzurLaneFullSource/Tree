local var0 = class("Dorm3dARScene", import("view.base.BaseUI"))
local var1 = "dorm3d/scenesres/scenes/arscene/arscene_scene"

function var0.getUIName(arg0)
	return "Dorm3DARUI"
end

function var0.preload(arg0, arg1)
	arg0.sceneName = "ARScene"

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOn(false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower(var1), arg0.sceneName, LoadSceneMode.Additive, function(arg0, arg1)
				arg0()
			end)
		end,
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()
			arg0()
		end,
		arg1
	})
end

function var0.init(arg0)
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	return
end

function var0.willExit(arg0)
	SceneOpMgr.Inst:UnloadSceneAsync(string.lower(var1), arg0.sceneName)
end

function var0.findUI(arg0)
	arg0.backBtn = arg0:findTF("BackBtn")

	local var0 = arg0:findTF("MenuList")

	arg0.resetBtn = arg0:findTF("ResetBtn", var0)
	arg0.showPlaneBtn = arg0:findTF("ShowPlaneBtn", var0)
	arg0.hidePlaneBtn = arg0:findTF("HidePlaneBtn", var0)

	local var1 = arg0:findTF("TipText")

	arg0.tipCheckPlane = arg0:findTF("CheckPlaneText", var1)
	arg0.tipInsPrefab = arg0:findTF("InsPrefabText", var1)
	arg0.tipDistance = arg0:findTF("DistanceText", var1)

	setText(arg0.tipCheckPlane, "请检测一个平面")
	setText(arg0.tipInsPrefab, "长按平面呼出角色")
	setText(arg0.tipDistance, "距离太近隐藏角色")
	setActive(arg0.tipCheckPlane, false)
	setActive(arg0.tipInsPrefab, false)
	setActive(arg0.tipDistance, false)

	local var2 = GameObject.Find("ScriptHander")

	arg0.aiHelperSC = GetComponent(var2, "ARHelper")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.resetBtn, function()
		arg0.aiHelperSC:ResetAll()
	end, SFX_PANEL)
	onButton(arg0, arg0.showPlaneBtn, function()
		arg0.aiHelperSC:ShowAllPlane(true)
	end, SFX_PANEL)
	onButton(arg0, arg0.hidePlaneBtn, function()
		arg0.aiHelperSC:ShowAllPlane(false)
	end, SFX_PANEL)

	function arg0.aiHelperSC.planeCountCB(arg0, arg1)
		local var0 = arg0 > 0

		setActive(arg0.tipCheckPlane, not var0)
		setActive(arg0.tipInsPrefab, var0 and not arg1)
	end

	function arg0.aiHelperSC.distanceCB(arg0)
		pg.TipsMgr.GetInstance():ShowTips("距离过近，以后会隐藏")
	end

	function arg0.aiHelperSC.insPrefabFailCB()
		pg.TipsMgr.GetInstance():ShowTips("距离过近，呼出角色失败")
	end

	function arg0.aiHelperSC.insPrefabSuccCB()
		pg.TipsMgr.GetInstance():ShowTips("呼出角色成功")
		arg0.aiHelperSC:StopPlaneCheck()
	end
end

return var0
