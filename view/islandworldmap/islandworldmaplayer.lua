local var0_0 = class("IslandWorldMapLayer", import("view.base.BaseUI"))
local var1_0 = "1"

function var0_0.getUIName(arg0_1)
	return "IslandWorldMapUI"
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	arg0_3.ad = findTF(arg0_3._tf, "ad")

	arg0_3:initPanel()
	arg0_3:initButtonEvent()
	arg0_3:initMapTestButton()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3.ad)
end

function var0_0.initPanel(arg0_4)
	arg0_4.mapContainer = IslandMapContainer.New(findTF(arg0_4.ad, "map"), arg0_4)

	arg0_4.mapContainer:loadMap()

	arg0_4.buildPanel = IslandMapBuildPanel.New(findTF(arg0_4.ad, "panel/buildDetailPanel"), arg0_4)
	arg0_4.missionPanel = IslandMissionPanel.New(findTF(arg0_4.ad, "panel/missionPanel"), arg0_4)

	arg0_4.buildPanel:setActive(false)
	arg0_4.missionPanel:setActive(false)
end

function var0_0.initButtonEvent(arg0_5)
	arg0_5.tempIndex = 0

	onButton(arg0_5, findTF(arg0_5.ad, "ui/btnBuild"), function()
		if arg0_5.tempIndex % 2 == 0 then
			arg0_5.mapContainer:setScale(2)
		else
			arg0_5.mapContainer:setScale(1)
		end

		arg0_5.tempIndex = arg0_5.tempIndex + 1
	end, SFX_CONFIRM)
	onButton(arg0_5, findTF(arg0_5.ad, "ui/btnClose"), function()
		arg0_5:closeView()
	end, SFX_CONFIRM)
end

function var0_0.initMapTestButton(arg0_8)
	arg0_8.btnMapTpl = findTF(arg0_8.ad, "ui/btnMapGuide")

	setActive(arg0_8.btnMapTpl, false)

	for iter0_8, iter1_8 in ipairs(pg.island_map.all) do
		local var0_8 = pg.island_map[iter1_8]

		if var0_8.sceneName and var0_8.sceneName ~= "" then
			local var1_8 = tf(instantiate(arg0_8.btnMapTpl))

			SetParent(var1_8, findTF(arg0_8.ad, "ui/mapGuide"))
			setActive(var1_8, true)

			local var2_8 = findTF(var1_8, "text")

			setText(var2_8, "跳转地图: " .. var0_8.name)
			onButton(arg0_8, var1_8, function()
				arg0_8:emit(IslandWorldMapMediator.GO_ISLAND, var0_8.id)
				arg0_8:closeView()
			end, SFX_CONFIRM)
		end
	end
end

function var0_0.onBackPressed(arg0_10)
	arg0_10:closeView()
end

function var0_0.willExit(arg0_11)
	arg0_11.mapContainer:dispose()
	arg0_11.buildPanel:dispose()
	arg0_11.missionPanel:dispose()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.ad, arg0_11._tf)
end

return var0_0
