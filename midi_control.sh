#!/bin/bash

##############################
#  TOUCHDAW MIDI CONTROLLER  #
##############################

PA="alsa_output.pci-0000_00_1f.3.analog-stereo"
HECATE="alsa_output.usb-Edifier_Technology_Co._Ltd_HECATE_G1_GAMING_HEADSET-00.analog-stereo"

MIC_IN="alsa_input.pci-0000_00_1f.3.analog-stereo"
MIC_HECATE="alsa_input.usb-Edifier_Technology_Co._Ltd_HECATE_G1_GAMING_HEADSET-00.mono-fallback"

MIC_MI="bluez_card.9C_19_C2_20_59_54"
SPEAKER_MI="bluez_output.9C_19_C2_20_59_54.a2dp-sink" #bluez_output.9C_19_C2_20_59_54.a2dp-sink.monitor

mute_pb0=0
mute_pb1=0
mute_pb2=0
mute_pb3=0

count_pb0=0
count_pb1=0
count_pb2=0
count_pb3=0

aseqdump -p  "Midi Through" |
{
  CURRENT_STATE_PB0=`amixer get Headphone | egrep 'Playback.*?\[o' | egrep -o '\[o.+\]'`
  CURRENT_STATE_PB1=`amixer get Speaker | egrep 'Playback.*?\[o' | egrep -o '\[o.+\]'`

  pactl set-source-volume $MIC_IN 8%

  if [[ $CURRENT_STATE_PB0 == '[off]' ]]; then #if [[ "${debugMode}" = "true" ]]; then
    mute_pb0=0
  else
    mute_pb0=1
  fi

  if [[ $CURRENT_STATE_PB1 == '[off]' ]]; then
    mute_pb1=0
  else
    mute_pb1=1
  fi

  # Ignore first two output lines of aseqdump (info and header)
  # read
  # read
  while IFS=" ," read src ev1 ev2 ch label1 ctrl_no label2 ctrl_value rest
  do
    case $ctrl_no in
      #------------------------------------------------------------
      16) # mute channel 0
        count_pb0=$((count_pb0+1))
        if [ $count_pb0 = 2 ]; then
          if [ $mute_pb0 = 0 ]; then
            pactl set-sink-mute $PA false
            mute_pb0=1
            count_pb0=0
          elif [ $mute_pb0 = 1 ]; then
            pactl set-sink-mute $PA true
            mute_pb0=0
            count_pb0=0
          fi
        fi
      ;;
      #------------------------------------------------------------
      17) # mute channel 1
        count_pb1=$((count_pb1+1))
        if [ $count_pb1 = 2 ]; then
          if [ $mute_pb1 = 0 ]; then
            pactl set-sink-mute $HECATE false
            mute_pb1=1
            count_pb1=0
          elif [ $mute_pb1 = 1 ]; then
            pactl set-sink-mute $HECATE true
            mute_pb1=0
            count_pb1=0
          fi
        fi
      ;;
      #------------------------------------------------------------
      23) # mute channel 2
        count_pb2=$((count_pb2+1))
        if [ $count_pb2 = 2 ]; then
          if [ $mute_pb2 = 0 ]; then
            pactl set-source-mute $MIC_IN false
            mute_pb2=1
            count_pb2=0
          elif [ $mute_pb2 = 1 ]; then
            pactl set-source-mute $MIC_IN true
            mute_pb2=0
            count_pb2=0
          fi
        fi
      ;;
      #------------------------------------------------------------
      18) # mute channel 3
        count_pb3=$((count_pb3+1))
        if [ $count_pb3 = 2 ]; then
          if [ $mute_pb3 = 0 ]; then
            pactl set-sink-mute $SPEAKER_MI false
            mute_pb3=1
            count_pb3=0
          elif [ $mute_pb3 = 1 ]; then
            pactl set-sink-mute $SPEAKER_MI true
            mute_pb3=0
            count_pb3=0
          fi
        fi
      ;;
      # *) echo "Other controller";;
    esac
    case $ev1 in
      Pitch)
        #------------------------------------------------------------
        if [ $ch = 0 ]; then # slide channel 0
          if [ $ctrl_no -lt -7475 ]; then
            pactl set-sink-volume $PA 0%
          elif [ $ctrl_no -gt -7475 ] && [ $ctrl_no -lt -6658 ]; then
            pactl set-sink-volume $PA 5%
          elif [ $ctrl_no -gt -6658 ] && [ $ctrl_no -lt -5841 ]; then
            pactl set-sink-volume $PA 10%
          elif [ $ctrl_no -gt -5841 ] && [ $ctrl_no -lt -5024 ]; then
            pactl set-sink-volume $PA 15%
          elif [ $ctrl_no -gt -5024 ] && [ $ctrl_no -lt -4207 ]; then
            pactl set-sink-volume $PA 20%
          elif [ $ctrl_no -gt -4207 ] && [ $ctrl_no -lt -3390 ]; then
            pactl set-sink-volume $PA 25%
          elif [ $ctrl_no -gt -3390 ] && [ $ctrl_no -lt -2573 ]; then
            pactl set-sink-volume $PA 30%
          elif [ $ctrl_no -gt -2573 ] && [ $ctrl_no -lt -1756 ]; then
            pactl set-sink-volume $PA 35%
          elif [ $ctrl_no -gt -1756 ] && [ $ctrl_no -lt -939 ]; then
            pactl set-sink-volume $PA 40%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt -122 ]; then
            pactl set-sink-volume $PA 45%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt 695 ]; then
            pactl set-sink-volume $PA 50%
          elif [ $ctrl_no -gt 695 ] && [ $ctrl_no -lt 1512 ]; then
            pactl set-sink-volume $PA 55%
          elif [ $ctrl_no -gt 1512 ] && [ $ctrl_no -lt 2329 ]; then
            pactl set-sink-volume $PA 60%
          elif [ $ctrl_no -gt 2329 ] && [ $ctrl_no -lt 3146 ]; then
            pactl set-sink-volume $PA 65%
          elif [ $ctrl_no -gt 3146 ] && [ $ctrl_no -lt 3963 ]; then
            pactl set-sink-volume $PA 70%
          elif [ $ctrl_no -gt 3963 ] && [ $ctrl_no -lt 4780 ]; then
            pactl set-sink-volume $PA 75%
          elif [ $ctrl_no -gt 4780 ] && [ $ctrl_no -lt 5597 ]; then
            pactl set-sink-volume $PA 80%
          elif [ $ctrl_no -gt 5597 ] && [ $ctrl_no -lt 6414 ]; then
            pactl set-sink-volume $PA 85%
          elif [ $ctrl_no -gt 6414 ] && [ $ctrl_no -lt 7231 ]; then
            pactl set-sink-volume $PA 90%
          elif [ $ctrl_no -gt 7231 ] && [ $ctrl_no -lt 8048 ]; then
            pactl set-sink-volume $PA 95%
          elif [ $ctrl_no -gt 8048 ]; then
            pactl set-sink-volume $PA 100%
          fi
        #------------------------------------------------------------
        elif [ $ch = 1 ]; then # slide channel 1
          if [ $ctrl_no -lt -7475 ]; then
            pactl set-sink-volume $HECATE 0%
          elif [ $ctrl_no -gt -7475 ] && [ $ctrl_no -lt -6658 ]; then
            pactl set-sink-volume $HECATE 5%
          elif [ $ctrl_no -gt -6658 ] && [ $ctrl_no -lt -5841 ]; then
            pactl set-sink-volume $HECATE 10%
          elif [ $ctrl_no -gt -5841 ] && [ $ctrl_no -lt -5024 ]; then
            pactl set-sink-volume $HECATE 15%
          elif [ $ctrl_no -gt -5024 ] && [ $ctrl_no -lt -4207 ]; then
            pactl set-sink-volume $HECATE 20%
          elif [ $ctrl_no -gt -4207 ] && [ $ctrl_no -lt -3390 ]; then
            pactl set-sink-volume $HECATE 25%
          elif [ $ctrl_no -gt -3390 ] && [ $ctrl_no -lt -2573 ]; then
            pactl set-sink-volume $HECATE 30%
          elif [ $ctrl_no -gt -2573 ] && [ $ctrl_no -lt -1756 ]; then
            pactl set-sink-volume $HECATE 35%
          elif [ $ctrl_no -gt -1756 ] && [ $ctrl_no -lt -939 ]; then
            pactl set-sink-volume $HECATE 40%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt -122 ]; then
            pactl set-sink-volume $HECATE 45%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt 695 ]; then
            pactl set-sink-volume $HECATE 50%
          elif [ $ctrl_no -gt 695 ] && [ $ctrl_no -lt 1512 ]; then
            pactl set-sink-volume $HECATE 55%
          elif [ $ctrl_no -gt 1512 ] && [ $ctrl_no -lt 2329 ]; then
            pactl set-sink-volume $HECATE 60%
          elif [ $ctrl_no -gt 2329 ] && [ $ctrl_no -lt 3146 ]; then
            pactl set-sink-volume $HECATE 65%
          elif [ $ctrl_no -gt 3146 ] && [ $ctrl_no -lt 3963 ]; then
            pactl set-sink-volume $HECATE 70%
          elif [ $ctrl_no -gt 3963 ] && [ $ctrl_no -lt 4780 ]; then
            pactl set-sink-volume $HECATE 75%
          elif [ $ctrl_no -gt 4780 ] && [ $ctrl_no -lt 5597 ]; then
            pactl set-sink-volume $HECATE 80%
          elif [ $ctrl_no -gt 5597 ] && [ $ctrl_no -lt 6414 ]; then
            pactl set-sink-volume $HECATE 85%
          elif [ $ctrl_no -gt 6414 ] && [ $ctrl_no -lt 7231 ]; then
            pactl set-sink-volume $HECATE 90%
          elif [ $ctrl_no -gt 7231 ] && [ $ctrl_no -lt 8048 ]; then
            pactl set-sink-volume $HECATE 95%
          elif [ $ctrl_no -gt 8048 ]; then
            pactl set-sink-volume $HECATE 100%
          fi
        #------------------------------------------------------------
        elif [ $ch = 7 ]; then # slide channel 7
          if [ $ctrl_no -lt -7475 ]; then
            pactl set-source-volume $MIC_IN 0%
          elif [ $ctrl_no -gt -7475 ] && [ $ctrl_no -lt -6658 ]; then
            pactl set-source-volume $MIC_IN 0%
          elif [ $ctrl_no -gt -6658 ] && [ $ctrl_no -lt -5841 ]; then
            pactl set-source-volume $MIC_IN 1%
          elif [ $ctrl_no -gt -5841 ] && [ $ctrl_no -lt -5024 ]; then
            pactl set-source-volume $MIC_IN 1%
          elif [ $ctrl_no -gt -5024 ] && [ $ctrl_no -lt -4207 ]; then
            pactl set-source-volume $MIC_IN 2%
          elif [ $ctrl_no -gt -4207 ] && [ $ctrl_no -lt -3390 ]; then
            pactl set-source-volume $MIC_IN 2%
          elif [ $ctrl_no -gt -3390 ] && [ $ctrl_no -lt -2573 ]; then
            pactl set-source-volume $MIC_IN 3%
          elif [ $ctrl_no -gt -2573 ] && [ $ctrl_no -lt -1756 ]; then
            pactl set-source-volume $MIC_IN 3%
          elif [ $ctrl_no -gt -1756 ] && [ $ctrl_no -lt -939 ]; then
            pactl set-source-volume $MIC_IN 4%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt -122 ]; then
            pactl set-source-volume $MIC_IN 4%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt 695 ]; then
            pactl set-source-volume $MIC_IN 5%
          elif [ $ctrl_no -gt 695 ] && [ $ctrl_no -lt 1512 ]; then
            pactl set-source-volume $MIC_IN 5%
          elif [ $ctrl_no -gt 1512 ] && [ $ctrl_no -lt 2329 ]; then
            pactl set-source-volume $MIC_IN 6%
          elif [ $ctrl_no -gt 2329 ] && [ $ctrl_no -lt 3146 ]; then
            pactl set-source-volume $MIC_IN 6%
          elif [ $ctrl_no -gt 3146 ] && [ $ctrl_no -lt 3963 ]; then
            pactl set-source-volume $MIC_IN 7%
          elif [ $ctrl_no -gt 3963 ] && [ $ctrl_no -lt 4780 ]; then
            pactl set-source-volume $MIC_IN 7%
          elif [ $ctrl_no -gt 4780 ] && [ $ctrl_no -lt 5597 ]; then
            pactl set-source-volume $MIC_IN 8%
          elif [ $ctrl_no -gt 5597 ] && [ $ctrl_no -lt 6414 ]; then
            pactl set-source-volume $MIC_IN 8%
          elif [ $ctrl_no -gt 6414 ] && [ $ctrl_no -lt 7231 ]; then
            pactl set-source-volume $MIC_IN 9%
          elif [ $ctrl_no -gt 7231 ] && [ $ctrl_no -lt 8048 ]; then
            pactl set-source-volume $MIC_IN 9%
          elif [ $ctrl_no -gt 8048 ]; then
            pactl set-source-volume $MIC_IN 10%
          fi
        #------------------------------------------------------------
        elif [ $ch = 2 ]; then # slide channel 2
          if [ $ctrl_no -lt -7475 ]; then
            pactl set-sink-volume $SPEAKER_MI 0%
          elif [ $ctrl_no -gt -7475 ] && [ $ctrl_no -lt -6658 ]; then
            pactl set-sink-volume $SPEAKER_MI 5%
          elif [ $ctrl_no -gt -6658 ] && [ $ctrl_no -lt -5841 ]; then
            pactl set-sink-volume $SPEAKER_MI 10%
          elif [ $ctrl_no -gt -5841 ] && [ $ctrl_no -lt -5024 ]; then
            pactl set-sink-volume $SPEAKER_MI 15%
          elif [ $ctrl_no -gt -5024 ] && [ $ctrl_no -lt -4207 ]; then
            pactl set-sink-volume $SPEAKER_MI 20%
          elif [ $ctrl_no -gt -4207 ] && [ $ctrl_no -lt -3390 ]; then
            pactl set-sink-volume $SPEAKER_MI 25%
          elif [ $ctrl_no -gt -3390 ] && [ $ctrl_no -lt -2573 ]; then
            pactl set-sink-volume $SPEAKER_MI 30%
          elif [ $ctrl_no -gt -2573 ] && [ $ctrl_no -lt -1756 ]; then
            pactl set-sink-volume $SPEAKER_MI 35%
          elif [ $ctrl_no -gt -1756 ] && [ $ctrl_no -lt -939 ]; then
            pactl set-sink-volume $SPEAKER_MI 40%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt -122 ]; then
            pactl set-sink-volume $SPEAKER_MI 45%
          elif [ $ctrl_no -gt -939 ] && [ $ctrl_no -lt 695 ]; then
            pactl set-sink-volume $SPEAKER_MI 50%
          elif [ $ctrl_no -gt 695 ] && [ $ctrl_no -lt 1512 ]; then
            pactl set-sink-volume $SPEAKER_MI 55%
          elif [ $ctrl_no -gt 1512 ] && [ $ctrl_no -lt 2329 ]; then
            pactl set-sink-volume $SPEAKER_MI 60%
          elif [ $ctrl_no -gt 2329 ] && [ $ctrl_no -lt 3146 ]; then
            pactl set-sink-volume $SPEAKER_MI 65%
          elif [ $ctrl_no -gt 3146 ] && [ $ctrl_no -lt 3963 ]; then
            pactl set-sink-volume $SPEAKER_MI 70%
          elif [ $ctrl_no -gt 3963 ] && [ $ctrl_no -lt 4780 ]; then
            pactl set-sink-volume $SPEAKER_MI 75%
          elif [ $ctrl_no -gt 4780 ] && [ $ctrl_no -lt 5597 ]; then
            pactl set-sink-volume $SPEAKER_MI 80%
          elif [ $ctrl_no -gt 5597 ] && [ $ctrl_no -lt 6414 ]; then
            pactl set-sink-volume $SPEAKER_MI 85%
          elif [ $ctrl_no -gt 6414 ] && [ $ctrl_no -lt 7231 ]; then
            pactl set-sink-volume $SPEAKER_MI 90%
          elif [ $ctrl_no -gt 7231 ] && [ $ctrl_no -lt 8048 ]; then
            pactl set-sink-volume $SPEAKER_MI 95%
          elif [ $ctrl_no -gt 8048 ]; then
            pactl set-sink-volume $SPEAKER_MI 100%
          fi
        fi
      ;;
    esac
  done
}


# passo=817

#8176-8192=16368/20=318

# https://linux.reuf.nl/projects/midi.htm
# aseqdump -p "Midi Through"
# sh ./midi_control.sh
# pactl list short short
