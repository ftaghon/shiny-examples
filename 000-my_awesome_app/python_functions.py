import numpy as np
import pandas as pd
import openturns as ot
import openturns.viewer as viewer
from matplotlib import pylab as plt

ot.Log.Show(ot.Log.NONE)


def test_function(df):

    tmp = df[["dt" ,"name", "temp"]]
    tmp.dt = tmp.dt // 3600
    tmp = tmp.pivot(index="dt", columns="name", values="temp")

    return(tmp.corr())
    

def kernel_smoothing(sample):
    kernel = ot.KernelSmoothing()
    bandwidth = kernel.computeSilvermanBandwidth(ot.Sample(np.array(sample).reshape(-1, 1)))
    estimated = kernel.build(ot.Sample(np.array(sample).reshape(-1, 1)), bandwidth)
    
    # graph = distribution.drawPDF()
    graph = estimated.drawPDF()
    graph.setTitle("Kernel smoothing of temperature")
    #kernel_plot = estimated.drawPDF().getDrawable(0)
    # kernel_plot.setColor("blue")
    # graph.add(kernel_plot)
    # graph.setLegends(["original", "KS"])
    # graph.setLegendPosition("topright")
    view = viewer.View(graph)
    view.save('myplot.png')
    # plt.savefig('myplot.png')
