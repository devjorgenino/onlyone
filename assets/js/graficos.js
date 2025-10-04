function resizeChart(chart, size) {
	chart.options.legend.display = size.width > 200;
	chart.update();
}

function resizeCharts(charts) {
	for (i = 0; i < charts.length; i++) {
		charts[i].options.legend.display = window.innerWidth > 375;
		charts[i].update();
	}
}

function cargarGrafica() {
	$.ajax({
		type: "GET",
		url: "index.php?c=app&a=datosGrafica",
		success: function(data) {
			console.log(data);
			var datos = $.parseJSON(data);
			var color = Chart.helpers.color;
			var barChartData1 = {
				labels: datos.cuentasLabels,
				datasets: [
					{
						label: "Ingresos",
						backgroundColor: "#00FF7F",
						borderColor: "#00FF7F",
						borderWidth: 1,
						data: datos.ingresosValues
					},
					{
						label: "Egresos",
						backgroundColor: "#FF4500",
						borderColor: "#FF4500",
						borderWidth: 1,
						data: datos.egresosValues
					}
				]
			};
			var config1 = {
				type: "bar",
				data: barChartData1,
				options: {
					responsive: true,
					legend: {
						display: true,
						position: "bottom",
						labels: {
							fontSize: 14
						}
					},
					title: {
						display: false,
						position: "top",
						fontSize: 18,
						fontColor: color(chartColors.blue)
							.alpha(0.5)
							.rgbString(),
						text: "Ingresos/Egresos por Cuenta"
					},
					scales: {
						xAxes: [
							{
								stacked: true
							}
						],
						yAxes: [
							{
								stacked: true,
								ticks: {
									callback: function(value, index, values) {
										return formatNumber(value);
									}
								}
							}
						]
					},
					tooltips: {
						mode: "index",
						intersect: false,
						callbacks: {
							label: function(tooltipItem, data) {
								return formatNumber(tooltipItem.yLabel);
							}
						}
					},
					onClick: function(e) {
						clickChart(e, myBar, "movimientos");
					},
					onResize: function(chart, size) {
						resizeChart(chart, size);
					}
				}
			};
			var ctx1 = document.getElementById("chartIngEgrxCta2").getContext("2d");
			window.myBar = new Chart(ctx1, config1);

			var config2 = {
				type: "pie",
				data: {
					datasets: [
						{
							data: datos.saldosValues,
							backgroundColor: [
								"#b0cdff",
								"#a7ffcc",
								"#d3fcbf",
								"#fff389",
								"#0092ff"
							],
							label: "Saldos por Cuenta"
						}
					],
					labels: datos.cuentasLabels
				},
				options: {
					responsive: true,
					legend: {
						display: true,
						position: "left",
						labels: {
							fontSize: 14
						}
					},
					title: {
						display: false,
						position: "top",
						fontSize: 18,
						fontColor: color(chartColors.blue)
							.alpha(0.5)
							.rgbString(),
						text: "Saldos por Cuenta"
					},
					rotation: Math.PI,
					circumference: Math.PI,
					onClick: function(e) {
						clickChart(e, myPie, "movimientos");
					},
					onResize: function(chart, size) {
						resizeChart(chart, size);
					},
					tooltips: {
						callbacks: {
							label: function(tooltipItem, data) {
								var dataLabel = data.labels[tooltipItem.index];
								var value =
									": " +
									formatNumber(
										data.datasets[tooltipItem.datasetIndex].data[
											tooltipItem.index
										].toLocaleString()
									);
								if (Chart.helpers.isArray(dataLabel)) {
									dataLabel = dataLabel.slice();
									dataLabel[0] += value;
								} else {
									dataLabel += value;
								}
								return dataLabel;
							}
						}
					}
				}
			};
			var ctx2 = document.getElementById("chartSaldoxCta2").getContext("2d");
			window.myPie = new Chart(ctx2, config2);

			var config3 = {
				type: "doughnut",
				data: {
					datasets: [
						{
							data: datos.ingCatsValues,
							backgroundColor: [
								"#4682B4",
								"#1E90FF",
								"#3CB371",
								"#FFA500",
								"#48D1CC"
							],
							label: "Ingresos"
						}
					],
					labels: datos.ingCatsLabels
				},
				options: {
					responsive: true,
					legend: {
						display: true,
						position: "left",
						labels: {
							fontSize: 14
						}
					},
					title: {
						display: false,
						position: "top",
						fontSize: 18,
						fontColor: color(chartColors.blue)
							.alpha(0.5)
							.rgbString(),
						text: "Ingresos por Categoria"
					},
					animation: {
						animateScale: true,
						animateRotate: true
					},
					cutoutPercentage: 60,
					rotation: Math.PI,
					circumference: Math.PI,
					onClick: function(e) {
						clickChart(e, myDoughnut1, "movimientos");
					},
					onResize: function(chart, size) {
						resizeChart(chart, size);
					},
					tooltips: {
						callbacks: {
							label: function(tooltipItem, data) {
								var dataLabel = data.labels[tooltipItem.index];
								var value =
									": " +
									formatNumber(
										data.datasets[tooltipItem.datasetIndex].data[
											tooltipItem.index
										].toString()
									);
								if (Chart.helpers.isArray(dataLabel)) {
									dataLabel = dataLabel.slice();
									dataLabel[0] += value;
								} else {
									dataLabel += value;
								}
								return dataLabel;
							}
						}
					}
				}
			};

			var ctx3 = document.getElementById("chartIngxCat").getContext("2d");
			window.myDoughnut1 = new Chart(ctx3, config3);

			var config4 = {
				type: "doughnut",
				data: {
					datasets: [
						{
							data: datos.egrCatsValues,
							backgroundColor: [
								"#3CB371",
								"#FFA500",
								"#1E90FF",
								"#4682B4",
								"#48D1CC"
							],
							label: "Egresos"
						}
					],
					labels: datos.egrCatsLabels
				},
				options: {
					responsive: true,
					legend: {
						position: "left",
						labels: {
							fontSize: 14
						}
					},
					title: {
						display: false,
						position: "top",
						fontSize: 18,
						fontColor: color(chartColors.blue)
							.alpha(0.5)
							.rgbString(),
						text: "Egresos por Categoria"
					},
					animation: {
						animateScale: true,
						animateRotate: true
					},
					cutoutPercentage: 60,
					rotation: Math.PI,
					circumference: Math.PI,
					onClick: function(e) {
						clickChart(e, myDoughnut2, "movimientos");
					},
					onResize: function(chart, size) {
						resizeChart(chart, size);
					},
					tooltips: {
						callbacks: {
							label: function(tooltipItem, data) {
								var dataLabel = data.labels[tooltipItem.index];
								var value =
									": " +
									formatNumber(
										data.datasets[tooltipItem.datasetIndex].data[
											tooltipItem.index
										].toString()
									);
								if (Chart.helpers.isArray(dataLabel)) {
									dataLabel = dataLabel.slice();
									dataLabel[0] += value;
								} else {
									dataLabel += value;
								}
								return dataLabel;
							}
						}
					}
				}
			};
			var ctx4 = document.getElementById("chartEgrxCat").getContext("2d");
			window.myDoughnut2 = new Chart(ctx4, config4);

			/*
			var barChartData2 = {
				labels: datos.movsxCatsLabels,
				datasets: [
					{
						label: datos.cuentasLabels[0],
						backgroundColor: window.chartColors.red,
						data: datos.movsCatsValues
					},
					{
						label: datos.cuentasLabels[1],
						backgroundColor: window.chartColors.blue,
						data: datos.movsCatsValues1
					},
					{
						label: datos.cuentasLabels[2],
						backgroundColor: window.chartColors.green,
						data: datos.movsCatsValues2
					}
				]
			};

			var config5 = {
				type: "bar",
				data: barChartData2,
				options: {
					title: {
						display: false,
						position: "top",
						fontSize: 18,
						fontColor: color(chartColors.blue)
							.alpha(0.5)
							.rgbString(),
						text: "Movimientos por Categoria"
					},
					tooltips: {
						mode: "index",
						intersect: false,
						callbacks: {
							label: function(tooltipItem, data) {
								return formatNumber(tooltipItem.yLabel);
							}
						}
					},
					responsive: true,
					scales: {
						xAxes: [
							{
								stacked: true
							}
						],
						yAxes: [
							{
								stacked: true,
								ticks: {
									callback: function(value, index, values) {
										return formatNumber(value);
									}
								}
							}
						]
					},
					onClick: function(e) {
						clickChart(e, myBar2, "movimientos");
					},
					onResize: function(chart, size) {
						resizeChart(chart, size);
					}
				}
			};
			var ctx5 = document.getElementById("chart5").getContext("2d");
			window.myBar2 = new Chart(ctx5, config5);

			var chartData6 = {
				labels: datos.cuentasLabels,
				datasets: [
					{
						type: "line",
						label: "Saldo",
						borderColor: window.chartColors.blue,
						borderWidth: 2,
						fill: false,
						data: datos.saldosValues
					},
					{
						label: "Ingresos",
						backgroundColor: "#00FF7F",
						borderColor: "#00FF7F",
						borderWidth: 1,
						data: datos.ingresosValues
					},
					{
						label: "Egresos",
						backgroundColor: "#FF4500",
						borderColor: "#FF4500",
						borderWidth: 1,
						data: datos.egresosValues
					}
				]
			};
			var config6 = {
				type: "bar",
				data: chartData6,
				options: {
					responsive: true,
					title: {
						display: false,
						text: "Chart.js Combo Bar Line Chart"
					},
					tooltips: {
						mode: "index",
						intersect: true
					}
				}
			};
			var ctx6 = document.getElementById("chart6").getContext("2d");
			window.myMixedChart = new Chart(ctx6, config6);

			var config7 = {
				type: "radar",
				data: {
					labels: datos.cuentasLabels,
					datasets: [
						{
							label: "Saldos",
							backgroundColor: color(window.chartColors.red)
								.alpha(0.2)
								.rgbString(),
							borderColor: window.chartColors.red,
							pointBackgroundColor: window.chartColors.red,
							data: datos.saldosValues
						}
					]
				},
				options: {
					legend: {
						position: "top"
					},
					title: {
						display: false,
						text: "Chart.js Radar Chart"
					},
					scale: {
						ticks: {
							beginAtZero: true
						}
					}
				}
			};
			var ctx7 = document.getElementById("radar").getContext("2d");
			window.myRadar = new Chart(ctx7, config7);
*/
			var charts = new Array(
				myBar,
				myPie,
				myDoughnut1,
				myDoughnut2 /*,
				myBar2,
				myMixedChart,
				myRadar*/
			);
			resizeCharts(charts);
		},
		error: function() {
			console.log("error");
		}
	});
}
