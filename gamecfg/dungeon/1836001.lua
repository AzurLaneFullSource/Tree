return {
	map_id = 10001,
	id = 1836001,
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
						id = "TIEYIQINGFENG24-1"
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
							monsterTemplateID = 16643001,
							moveCast = true,
							delay = 0,
							score = 0,
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
							monsterTemplateID = 16643003,
							moveCast = true,
							delay = 0,
							score = 0,
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
							monsterTemplateID = 16643003,
							moveCast = true,
							delay = 0,
							score = 0,
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
							monsterTemplateID = 16643001,
							moveCast = true,
							delay = 0,
							score = 0,
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
					conditionType = 1,
					preWaves = {
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16643001,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								10,
								0,
								80
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16643003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								3,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16643102,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								55
							}
						},
						{
							monsterTemplateID = 16643003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								3,
								0,
								40
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16643001,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								10,
								0,
								30
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
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						102
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16643004,
							reinforceDelay = 6,
							score = 0,
							delay = 0,
							moveCast = true,
							corrdinate = {
								-10,
								0,
								55
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16643003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-8,
								0,
								80
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16643006,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								30,
								0,
								65
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16643006,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								30,
								0,
								45
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16643003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-8,
								0,
								30
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
					waveIndex = 104,
					conditionType = 1,
					preWaves = {
						103
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16643105,
							reinforceDelay = 6,
							score = 0,
							delay = 0,
							moveCast = true,
							corrdinate = {
								-10,
								0,
								65
							}
						},
						{
							monsterTemplateID = 16643104,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-10,
								0,
								45
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16643005,
							moveCast = true,
							delay = 0,
							score = 0,
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
							monsterTemplateID = 16643006,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								30,
								0,
								55
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16643003,
							moveCast = true,
							delay = 0,
							score = 0,
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
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						104
					},
					triggerParams = {
						id = "TIEYIQINGFENG24-2"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 105,
					conditionType = 0,
					preWaves = {
						502
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16646301,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 40,
								icon = "sairen"
							},
							buffList = {
								200280
							},
							phase = {
								{
									index = 0,
									switchParam = 1.5,
									switchTo = 1,
									switchType = 1,
									addWeapon = {
										692601
									},
									removeWeapon = {}
								},
								{
									index = 1,
									switchParam = 2,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										692602,
										692603,
										692604
									},
									removeWeapon = {}
								},
								{
									index = 2,
									switchParam = 5,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										692605
									},
									removeWeapon = {}
								},
								{
									switchType = 1,
									switchTo = 4,
									index = 3,
									switchParam = 2,
									setAI = 70125,
									addWeapon = {},
									removeWeapon = {
										692602,
										692603,
										692604,
										692605
									}
								},
								{
									index = 4,
									switchParam = 4,
									switchTo = 5,
									switchType = 1,
									removeWeapon = {},
									addWeapon = {
										692606,
										692607,
										692608
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 2,
									addWeapon = {
										692609,
										692610
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 3,
									removeWeapon = {
										692606,
										692607,
										692609,
										692610
									}
								},
								{
									switchType = 1,
									switchTo = 1,
									index = 7,
									switchParam = 5,
									setAI = 10001,
									addWeapon = {},
									removeWeapon = {
										692608
									}
								}
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 106,
					conditionType = 0,
					preWaves = {
						105
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16646302,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 60,
								icon = "sairen"
							},
							buffList = {
								200280
							},
							phase = {
								{
									switchType = 1,
									switchTo = 1,
									index = 0,
									switchParam = 1.5,
									setAI = 20006,
									addWeapon = {},
									removeWeapon = {}
								},
								{
									index = 1,
									switchParam = 6,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										694601,
										694602
									},
									removeWeapon = {}
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 2,
									switchParam = 6,
									setAI = 10001,
									addWeapon = {
										694603,
										694604
									},
									removeWeapon = {
										694601,
										694602
									}
								},
								{
									index = 3,
									switchParam = 2.5,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										694606
									},
									removeWeapon = {
										694603,
										694604
									}
								},
								{
									index = 4,
									switchParam = 2.7,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										694605
									},
									removeWeapon = {}
								},
								{
									switchType = 1,
									switchTo = 6,
									index = 5,
									switchParam = 2,
									setAI = 70093,
									addWeapon = {
										694607
									},
									removeWeapon = {
										694605,
										694606
									}
								},
								{
									index = 6,
									switchParam = 3,
									switchTo = 7,
									switchType = 1,
									addWeapon = {
										694608
									},
									removeWeapon = {}
								},
								{
									switchType = 1,
									switchTo = 8,
									index = 7,
									switchParam = 6,
									setAI = 10001,
									addWeapon = {},
									removeWeapon = {}
								},
								{
									switchType = 1,
									switchTo = 9,
									index = 8,
									switchParam = 1.5,
									setAI = 70093,
									addWeapon = {
										694609
									},
									removeWeapon = {
										694607
									}
								},
								{
									index = 9,
									switchParam = 0.5,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										694608,
										694609
									}
								}
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 107,
					conditionType = 0,
					preWaves = {
						106
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16646303,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 80,
								icon = "sairen"
							},
							buffList = {
								200280
							},
							phase = {
								{
									switchType = 1,
									switchTo = 1,
									index = 0,
									switchParam = 2,
									setAI = 20006,
									addWeapon = {},
									removeWeapon = {}
								},
								{
									index = 1,
									switchParam = 2,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										693801,
										693802
									},
									removeWeapon = {}
								},
								{
									index = 2,
									switchParam = 9,
									switchTo = 3,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										693801,
										693802
									}
								},
								{
									index = 3,
									setAI = 10001,
									addWeapon = {
										693805,
										693811
									},
									removeWeapon = {},
									switchType = {
										1,
										2
									},
									switchParam = {
										8,
										0.5
									},
									switchTo = {
										4,
										10
									}
								},
								{
									index = 4,
									addWeapon = {
										693810
									},
									removeWeapon = {
										693805,
										693811
									},
									switchType = {
										1,
										2
									},
									switchParam = {
										1,
										0.5
									},
									switchTo = {
										5,
										10
									}
								},
								{
									index = 5,
									addWeapon = {
										693809
									},
									removeWeapon = {},
									switchType = {
										1,
										2
									},
									switchParam = {
										7,
										0.5
									},
									switchTo = {
										6,
										10
									}
								},
								{
									index = 6,
									setAI = 70093,
									addWeapon = {},
									removeWeapon = {
										693809,
										693810
									},
									switchType = {
										1,
										2
									},
									switchParam = {
										0.1,
										0.5
									},
									switchTo = {
										7,
										10
									}
								},
								{
									index = 7,
									addWeapon = {
										693801,
										693802
									},
									removeWeapon = {},
									switchType = {
										1,
										2
									},
									switchParam = {
										2,
										0.5
									},
									switchTo = {
										8,
										10
									}
								},
								{
									index = 8,
									addWeapon = {},
									removeWeapon = {
										693801,
										693802
									},
									switchType = {
										1,
										2
									},
									switchParam = {
										9,
										0.5
									},
									switchTo = {
										9,
										10
									}
								},
								{
									switchParam = 2,
									switchTo = 11,
									index = 9,
									switchType = 1,
									setAI = 70093,
									addBuff = {
										8692
									},
									addWeapon = {},
									removeWeapon = {
										693801,
										693802,
										693805,
										693809,
										693810,
										693811,
										693812,
										693813,
										693814
									}
								},
								{
									switchParam = 2,
									switchTo = 11,
									index = 10,
									switchType = 1,
									setAI = 70093,
									addBuff = {
										8691
									},
									addWeapon = {},
									removeWeapon = {
										693801,
										693802,
										693805,
										693809,
										693810,
										693811,
										693812,
										693813,
										693814
									}
								},
								{
									index = 11,
									switchParam = 6.5,
									switchTo = 12,
									switchType = 1,
									addWeapon = {
										693813
									},
									removeWeapon = {}
								},
								{
									index = 12,
									switchParam = 10,
									switchTo = 13,
									switchType = 1,
									addWeapon = {
										693814,
										693815,
										693816,
										693817,
										693818
									},
									removeWeapon = {
										693813
									}
								},
								{
									index = 13,
									switchParam = 2,
									switchTo = 11,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										693814,
										693815,
										693816,
										693817,
										693818
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
						107
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
						id = "TIEYIQINGFENG24-3"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900449,
				configId = 900449,
				skinId = 599010,
				id = 1,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 350,
					air = 0,
					antiaircraft = 200,
					torpedo = 450,
					durability = 12000,
					reload = 400,
					armor = 0,
					dodge = 30,
					speed = 33,
					luck = 99,
					hit = 100
				},
				skills = {
					{
						id = 19580,
						level = 10
					},
					{
						id = 19590,
						level = 10
					},
					{
						id = 19002,
						level = 10
					},
					{
						id = 29902,
						level = 10
					},
					{
						id = 29902,
						level = 10
					},
					{
						id = 201018,
						level = 10
					}
				}
			},
			{
				tmpID = 900447,
				configId = 900447,
				skinId = 501010,
				id = 2,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 400,
					torpedo = 350,
					durability = 8000,
					reload = 400,
					armor = 0,
					dodge = 80,
					speed = 20,
					luck = 99,
					hit = 100
				},
				skills = {
					{
						id = 11040,
						level = 10
					},
					{
						id = 24012,
						level = 10
					}
				}
			},
			{
				tmpID = 900448,
				configId = 900448,
				skinId = 502090,
				id = 3,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 0,
					antiaircraft = 400,
					torpedo = 0,
					durability = 10000,
					reload = 400,
					armor = 0,
					dodge = 80,
					speed = 32,
					luck = 99,
					hit = 100
				},
				skills = {
					{
						id = 17450,
						level = 10
					},
					{
						id = 17460,
						level = 10
					},
					{
						id = 24152,
						level = 10
					}
				}
			}
		}
	}
}