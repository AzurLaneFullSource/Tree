local var0_0 = class("ANTTFFStoryCollectionPage", import("view.activity.CorePage.Helena.HelenaPTPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.scenario = ANTTFFScenarioPage.New(arg0_1._tf, arg0_1.event)

	arg0_1.scenario:SetCoreStoryPage(arg0_1)
	arg0_1.scenario:RegisterView(arg0_1.coreActivityUI)

	arg0_1.loader = AutoLoader.New()
	arg0_1.mapGroup = {}
	arg0_1.currentBG = nil
end

return var0_0
