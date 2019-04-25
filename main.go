package main

import (
	"flag"
	// "math/rand"
	"net/http"
	// "time"

	"github.com/gin-gonic/gin"
	// "github.com/prometheus/client_golang/prometheus"
	// "github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	// booksSold = promauto.NewCounterVec(prometheus.CounterOpts{
	// 	Name: "books_sold",
	// 	Help: "The total number of books sold",
	// },
	// 	[]string{"genre"})

	// timeSpent = promauto.NewSummaryVec(prometheus.SummaryOpts{
	// 	Name:       "time_spent",
	// 	Help:       "Time spent to buy a book",
	// 	Objectives: map[float64]float64{0.1: 0.09, 0.5: 0.05, 0.9: 0.01, 0.99: 0.001},
	// },
	// 	[]string{"genre"})

	// booksSoldPages = promauto.NewHistogramVec(prometheus.HistogramOpts{
	// 	Name:    "books_sold_pages",
	// 	Help:    "Books sold with number of pages",
	// 	Buckets: []float64{20.0, 100.0, 150.0, 200.0},
	// },
	// 	[]string{"genre"})

	// onlineUsers = promauto.NewGauge(prometheus.GaugeOpts{
	// 	Name: "online_users",
	// 	Help: "Users that are online",
	// })

	// requestsMetric = promauto.NewCounterVec(prometheus.CounterOpts{
	// 	Name: "requests_total",
	// 	Help: "The total number of requests",
	// },
	// 	[]string{"code", "method", "path"})

	// requestsMetricSummary = promauto.NewSummaryVec(prometheus.SummaryOpts{
	// 	Name:       "requests_total_summary",
	// 	Help:       "Number of requests with time in nanoseconds",
	// 	Objectives: map[float64]float64{0.1: 0.09, 0.5: 0.05, 0.9: 0.01, 0.99: 0.001},
	// },
	// 	[]string{"code", "method", "path"})
)

func main() {

	prometheusInit()

	r := gin.Default()


	r.GET("/", func(c *gin.Context) {
		// t0 := time.Now().UnixNano()
		// onlineUsers.Inc()
		// requestsMetric.WithLabelValues("200", "GET", "/").Inc()
		c.JSON(200, gin.H{
			"message": "Look at all the books we have!",
		})
		// requestsMetricSummary.WithLabelValues("200", "GET", "/").Observe(float64(time.Now().UnixNano() - t0))
	})

	r.POST("/buy/:genre", func(c *gin.Context) {
		genre := c.Param("genre")
		// t0 := time.Now().UnixNano()
		// booksSold.WithLabelValues(genre).Inc()
		// timeSpent.WithLabelValues(genre).Observe(rand.Float64() * 100)
		// booksSoldPages.WithLabelValues(genre).Observe(rand.Float64() * 200)
		// onlineUsers.Dec()
		// requestsMetric.WithLabelValues("200", "POST", "/buy/:genre").Inc()
		c.JSON(200, gin.H{
			"message": "Thank you for purchasing a book",
			"genre": genre,
		})
		// requestsMetricSummary.WithLabelValues("200", "POST", "/buy/:genre").Observe(float64(time.Now().UnixNano() - t0))
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}

func prometheusInit() {
	flag.Parse()
	http.Handle("/metrics", promhttp.Handler())
	go http.ListenAndServe(":9090", nil)
}
