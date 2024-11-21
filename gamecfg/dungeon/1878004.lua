return {
	map_id = 10001,
	id = 1878004,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-80,
				20,
				90,
				70
			},
			playerArea = {
				-80,
				20,
				45,
				68
			},
			enemyArea = {},
			fleetCorrdinate = {
				-80,
				0,
				75
			},
			waves = {
				{
					triggerType = 1,
					waveIndex = 100,
					preWaves = {},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 3,
					waveIndex = 501,
					preWaves = {
						100
					},
					triggerParams = {
						id = "WEIXIANFAMINGPOJINZHONGGUANQIA15-1"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						501
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16688002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16688003,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16688003,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16688002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								5,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 0,
					preWaves = {
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16688004,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-10,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16688005,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-10,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16688002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								0,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16688002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								0,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						102
					},
					triggerParams = {
						id = "WEIXIANFAMINGPOJINZHONGGUANQIA15-2"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						502
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16688105,
							delay = 0.1,
							corrdinate = {
								-10,
								0,
								70
							},
							bossData = {
								hpBarNum = 50,
								icon = ""
							}
						},
						{
							monsterTemplateID = 16688106,
							delay = 0.1,
							corrdinate = {
								-10,
								0,
								40
							},
							bossData = {
								hpBarNum = 50,
								icon = ""
							},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									switchType = 1,
									switchTo = 2,
									index = 1,
									switchParam = 2.5,
									setAI = 10001,
									addWeapon = {
										3223001,
										3223002
									}
								},
								{
									switchParam = 1,
									switchTo = 3,
									index = 2,
									switchType = 1,
									setAI = 70188
								},
								{
									index = 3,
									switchParam = 8.5,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3223003
									},
									removeWeapon = {
										3223001,
										3223002
									}
								},
								{
									switchType = 1,
									switchTo = 5,
									index = 4,
									switchParam = 10,
									setAI = 10001,
									addWeapon = {
										3223004,
										3223005
									},
									removeWeapon = {
										3223003
									}
								},
								{
									switchType = 1,
									switchTo = 1,
									index = 5,
									switchParam = 2.5,
									setAI = 70188,
									removeWeapon = {
										3223004,
										3223005
									}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						103
					},
					triggerParams = {}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 503,
					preWaves = {
						900
					},
					triggerParams = {
						id = "WEIXIANFAMINGPOJINZHONGGUANQIA15-3"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900473,
				configId = 900473,
				skinId = 11100010,
				id = 1,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 111010,
						level = 10
					},
					{
						id = 111020,
						level = 10
					}
				}
			},
			{
				tmpID = 900474,
				configId = 900474,
				skinId = 11100020,
				id = 2,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 111040,
						level = 10
					},
					{
						id = 111050,
						level = 10
					}
				}
			},
			{
				tmpID = 900475,
				configId = 900475,
				skinId = 11100030,
				id = 3,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 111070,
						level = 10
					},
					{
						id = 111090,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900470,
				configId = 900470,
				skinId = 205010,
				id = 1,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 250,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 800,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 10300,
						level = 10
					},
					{
						id = 2,
						level = 10
					},
					{
						id = 151,
						level = 10
					},
					{
						id = 340,
						level = 10
					},
					{
						id = 201167,
						level = 3
					}
				}
			},
			{
				tmpID = 900471,
				configId = 900471,
				skinId = 205130,
				id = 2,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 400,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 15680,
						level = 10
					},
					{
						id = 15690,
						level = 10
					},
					{
						id = 15700,
						level = 10
					},
					{
						id = 152,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			},
			{
				tmpID = 900472,
				configId = 900472,
				skinId = 299020,
				id = 3,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 400,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 19030,
						level = 10
					},
					{
						id = 19040,
						level = 10
					},
					{
						id = 19002,
						level = 10
					},
					{
						id = 152,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			}
		}
	}
}
