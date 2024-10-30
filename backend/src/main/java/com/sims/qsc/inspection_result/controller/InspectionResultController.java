package com.sims.qsc.inspection_result.controller;

import java.util.List;

import com.sims.qsc.inspection_result.service.inspectionResultPopup.InspectionResultPopupService;
import com.sims.qsc.inspection_result.vo.InspectionResultCategoryDetailResponse;
import com.sims.qsc.inspection_result.vo.InspectionResultRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.sims.qsc.inspection_result.service.InspectionResultService;
import com.sims.qsc.inspection_result.vo.InspectionResultDetailResponse;
import com.sims.qsc.inspection_result.vo.InspectionResultResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/qsc")
@Slf4j
public class InspectionResultController {
	
	private final InspectionResultService inspectionResultService;
	private final InspectionResultPopupService inspectionResultPopupService;

	/**
	 * 요구사항 작업 - 가맹점 점검 결과 페이지
	 * @return
	 */
    @GetMapping("/inspection/result")
    public String inspectionResult() {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
  	  	String username = auth.getName();
		
  	  	if(username.equals("anonymousUser")) {
			return "redirect:/login";
		}
		
        return "qsc/inspection_result/result_list";
    }
    
    /**
     * 요구사항 작업 - 가맹점 점검 결과 목록
     * @return List<InspectionResultResponse>
     */
    @ResponseBody
    @GetMapping("/inspection/result/list")
    public ResponseEntity<List<InspectionResultResponse>> selectInspectionResultList() {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
  	  	String username = auth.getName();
  	  	
  	  	List<InspectionResultResponse> list = inspectionResultService.selectInspectionResultList(username);

  	  	if(list.isEmpty()) {
  	  		return new ResponseEntity<>(HttpStatus.NOT_FOUND);
  	  	} else {
  	  		return new ResponseEntity<>(list, HttpStatus.OK);
  	  	}
  	  
    }

	@ResponseBody
	@PostMapping("/inspection/result/list/search")
	public ResponseEntity<List<InspectionResultResponse>> selectInspectionResultListSearch
																		(@RequestBody InspectionResultRequest request) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String username = auth.getName();
		List<InspectionResultResponse> list = inspectionResultService.selectInspectionResultListBySearch(request, username);

		if(list.isEmpty()) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		} else {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}
	}
    

    @PostMapping("/popup/inspection/result")
    public String openInspectionPopup(@RequestParam("inspectionContent") String content, Model model) {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
  	  	String username = auth.getName();
	  	  if(username.equals("anonymousUser")) {
			  return "redirect:/login";
		  }
        // content 데이터를 모델에 담아 팝업으로 넘김
        model.addAttribute("content", content);
        return "qsc/inspection_result/popup_inspection_result"; // 팝업 창으로 이동
    }
    
    @GetMapping("/popup/inspection/result/detail/{inspResultId}")
    public ResponseEntity<InspectionResultDetailResponse> selectInspectionResultDetail
															(@PathVariable("inspResultId") int inspResultId) {
    	InspectionResultDetailResponse inspResult =
				inspectionResultPopupService.selectInspectionResultDetailByInspResultId(inspResultId);
    	if(inspResult == null) {
    		return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    	} else {
    		return new ResponseEntity<>(inspResult, HttpStatus.OK);
    	}
    }

	@GetMapping("/popup/inspection/result/category/{inspResultId}")
	public ResponseEntity<List<InspectionResultCategoryDetailResponse>> selectInspectionResultCategory
															(@PathVariable("inspResultId") int inspResultId) {
		List<InspectionResultCategoryDetailResponse> list =
					inspectionResultPopupService.selectInspectionResultCategoryDetailByInspResultId(inspResultId);
		if(list.isEmpty()) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		} else {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}
	}


    
    
}
