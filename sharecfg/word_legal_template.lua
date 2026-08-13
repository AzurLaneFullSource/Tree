pg = pg or {}

local var0_0 = pg

var0_0.word_legal_template = {
	subFolderName = "word_legal_subList",
	subList = {
		"word_legal_template_1",
		"word_legal_template_2"
	},
	indexs = {
		合 = 1,
		C = 1,
		M = 1,
		["2"] = 2,
		L = 1,
		Q = 2,
		埃 = 2,
		约 = 2,
		P = 1,
		A = 1,
		N = 2,
		D = 1,
		S = 1,
		O = 2,
		亚 = 2,
		Z = 2,
		Ä = 2,
		J = 1,
		K = 2,
		V = 2,
		Y = 2,
		F = 1,
		I = 2,
		H = 1,
		基 = 2,
		W = 1,
		朴 = 2,
		马 = 2,
		G = 1,
		U = 1,
		Ō = 2,
		T = 1,
		E = 1,
		R = 1,
		É = 2,
		B = 1
	}
}

setmetatable(var0_0.word_legal_template, {
	__index = function(arg0_1, arg1_1)
		if arg1_1 == nil then
			return nil
		end

		local var0_1 = var0_0.word_legal_template.indexs[arg1_1]

		if var0_1 == nil then
			return nil
		end

		local var1_1 = var0_0.word_legal_template.subList[var0_1]

		if var0_0[var1_1] == nil then
			require("ShareCfg.word_legal_subList." .. var1_1)
		end

		return var0_0[var1_1][arg1_1]
	end
})
