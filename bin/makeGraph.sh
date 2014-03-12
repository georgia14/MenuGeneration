#!/bin/sh +x

_input="georgiaScaled_std_MON_noMET.xml"

_file="test.txt"
rm -rf $_file

_macro="test.C"
rm -rf $_macro

echo "void test() {" >> $_macro

cat $_input | grep "Total L1 Rate (with overlaps)" | awk '{print $7}' > $_file &
cat $_file

# x Array : bandwidth values
_n=$(wc -l < $_file)
echo "x Array dimension="$_n

_lumiarray=( `cat $_file` )
_xarray=$(IFS=, ; echo "${_lumiarray[*]}")

echo $_xarray 
echo "Double_t x["$_n"]={"$_xarray"};" >> $_macro
rm -rf $_file

#bandwidth error array
cat $_input | grep "Total L1 Rate (with overlaps)" | awk '{print $9}' > $_file &
cat $_file

_earray=( `cat $_file` )
_xearray=$(IFS=, ; echo "${_earray[*]}")

echo $_xearray
echo "Double_t ex["$_n"]={"$_xearray"};" >> $_macro


# Trigger name array
_triggerArray=( L1_SingleEG L1_SingleIsoEG L1_SingleMu L1_SingleIsoMu L1_SingleTau L1_SingleIsoTau L1_isoEG_EG L1_isoMu_Mu L1_isoTau_Tau L1_isoEG_Mu L1_isoMu_EG L1_isoEG_Tau L1_isoMu_Tau L1_SingleJetC L1_DoubleJet L1_QuadJetC L1_SingleIsoEG_CJet L1_SingleMu_CJet L1_SingleIsoEG_HTM L1_SingleMu_HTM L1_HTM L1_HTT )


echo ${_triggerArray[0]}
# y arrays: threshold values
cat $_input | grep ${_triggerArray[0]} | awk '{print $2}' > $_file &
cat $_file

_yarray1=( `cat $_file` )
_yarray=$(IFS=, ; echo "${_yarray1[*]}")

echo $_yarray
echo "Double_t y["$_n"]={"$_yarray"};" >> $_macro

# threshold error low
rm -rf $_file
cat $_input | grep ${_triggerArray[0]} | awk '{print $7}' > $_file &
cat $_file

_yelarray0=( `cat $_file` )
_yelarray=$(IFS=, ; echo "${_yelarray0[*]}")

echo $_yelarray
echo "Double_t eyl["$_n"]={"$_yelarray"};" >> $_macro

# threshold error high
rm -rf $_file
cat $_input | grep ${_triggerArray[0]} | awk '{print $8}' > $_file &
cat $_file

_yeharray0=( `cat $_file` )
_yeharray=$(IFS=, ; echo "${_yeharray0[*]}")

echo $_yeharray
echo "Double_t eyh["$_n"]={"$_yeharray"};" >> $_macro


unset _yarray0; unset _yarray
unset _yelarray0; unset _yelarray
unset _yeharray0; unset _yeharray

echo "TGraphAsymmErrors *g= new TGraphAsymmErrors("$_n",x,y,ex,ex,eyl,eyh);" >> $_macro
echo "TCanvas *c1=new TCanvas(\"can1\",\"\");" >> $_macro
echo "gPad->SetGridx(); gPad->SetGridy();" >> $_macro
echo "g->Draw(\"AP4\");" >> $_macro
echo "g->GetYaxis()->SetRangeUser(5.,60.);" >> $_macro
echo "g->SetTitle(\";Bandwidth (kHz);Threshold (GeV)\");" >> $_macro
echo "g->SetFillColor(3);" >> $_macro
echo "}" >> $_macro

root -l $_macro
